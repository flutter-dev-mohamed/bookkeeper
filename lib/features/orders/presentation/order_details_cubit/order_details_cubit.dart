import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/app_notifications/app_notifications.dart';
import 'package:shagaf_ledger/core/app_notifications/notifications/inventory_changes.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/cancel_order.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/get_order_details.dart';
import 'package:shagaf_ledger/features/orders/presentation/order_details_cubit/order_details_effect.dart';

part 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final GetOrderDetails _getOrderDetails;
  final CancelOrder _cancelOrder;
  final AppNotifications _appNotifications;

  OrderDetailsCubit({
    required this._getOrderDetails,
    required this._cancelOrder,
    required this._appNotifications,
  }) : super(OrderDetailsInitial());

  @override
  Future<void> close() {
    _effectsController.close();
    return super.close();
  }

  //  ——————————————————————————————————————————————————————————————————————————  effect streamer start
  final _effectsController = StreamController<OrderDetailsEffect>.broadcast();

  Stream<OrderDetailsEffect> get effects => _effectsController.stream;

  //  ——————————————————————————————————————————————————————————————————————————  effect streamer end

  void getOrder({required int orderId, bool didCancelOrder = false}) async {
    emit(OrderDetailsLoading());

    final orderDetails = await _getOrderDetails(orderId);

    orderDetails.fold(
      (error) => emit(OrderDetailsFailure(message: error.message)),
      (details) => emit(
        GotOrderDetails(
          order: details.order,
          items: details.items,
          didCancelOrder: didCancelOrder,
        ),
      ),
    );
  }

  void cancelOrder({
    required int orderId,
    required List<OrderItem> items,
  }) async {
    final currentState = state;

    emit(OrderDetailsLoading());

    final res = await _cancelOrder(
      CancelOrderParams(orderId: orderId, items: items),
    );

    // TODO: YOU SHOULD MAINTAIN THE LAST SUCCESSFUL STATE AND USE EFFECTS TO SHOW AN ERROR DIALOG WITH THE ERROR MESSAGE
    // TODO: OrderDetailsFailure SHOULD BE ONLY EMITTED IF THE INITIAL FETCHING FAILS
    res.fold((error) => _onFailure(error.message, currentState), (_) {
      getOrder(orderId: orderId, didCancelOrder: true);

      _appNotifications.notifyInventoryChanged(
        // map all the order items and send a notification for each item/product
        InventoryChanges(
          inventoryChanges: items.map((item) {
            return InventoryChange(
              productId: item.productId,
              quantity: item.quantity,
              changeType: InventoryChangeType.addition,
            );
          }).toList(),
        ),
      );
    });
  }

  void _onFailure(String message, OrderDetailsState state) {
    _effectsController.add(ShowOrderDetailsErrorDialog(message: message));
    emit(state);
  }
}
