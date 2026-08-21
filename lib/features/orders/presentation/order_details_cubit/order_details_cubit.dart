import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/cancel_order.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/get_order_details.dart';

part 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final GetOrderDetails _getOrderDetails;
  final CancelOrder _cancelOrder;

  OrderDetailsCubit({
    required this._getOrderDetails,
    required this._cancelOrder,
  }) : super(OrderDetailsInitial());

  void getOrder({required int orderId}) async {
    emit(OrderDetailsLoading());

    final orderDetails = await _getOrderDetails(orderId);

    orderDetails.fold(
      (error) => emit(OrderDetailsFailure(message: error.message)),
      (details) =>
          emit(GotOrderDetails(order: details.order, items: details.items)),
    );
  }

  void cancelOrder({
    required int orderId,
    required List<OrderItem> items,
  }) async {
    emit(OrderDetailsLoading());

    final res = await _cancelOrder(
      CancelOrderParams(orderId: orderId, items: items),
    );

    res.fold(
      (error) => emit(OrderDetailsFailure(message: error.message)),
      (_) => getOrder(orderId: orderId),
    );
  }
}
