import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/functions/date_formatting.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/get_orders.dart';
import 'package:shagaf_ledger/features/orders/presentation/orders_cubit/orders_effect.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetOrders _getOrders;

  OrdersCubit({required this._getOrders}) : super(OrdersInitial()) {
    loadOrders(dateFilter: DateTime.now());
  }

  final _effectsController = StreamController<OrdersEffect>.broadcast();

  Stream<OrdersEffect> get effects => _effectsController.stream;

  void loadOrders({required DateTime dateFilter}) async {
    final currentState = state;

    emit(OrdersLoading());

    final dateString = dateFormatting(dateFilter);

    final orders = await _getOrders(dateString);

    orders.fold(
      // emit last successful state
      (error) => _onFailure(error.message, currentState),

      (orders) => emit(
        OrdersLoaded(orders: orders.reversed.toList(), dateFilter: dateFilter),
      ),
    );
  }

  void _onFailure(String message, OrdersState state) {
    _effectsController.add(ShowOrdersErrorDialog(message: message));

    emit(state);
  }

  // this function is used to reduce DB requests
  // in case of cancelling an order: call this function after the cancelling is succeeded
  // in case of adding on order: call after adding succeeded
  void updateOrdersList({
    required OrderEntity newOrder,
    bool add = false,
    int? atIndex,
  }) {
    final currentState = state;
    if (currentState is! OrdersLoaded) return;

    if (add) {
      final updatedOrders = [...currentState.orders, newOrder];
      emit(currentState.copyWith(orders: updatedOrders));
    } else {
      final index =
          atIndex ??
          currentState.orders.indexWhere((order) => order.id == newOrder.id);

      // ensure the item actually exists in the list for safety
      if (index != -1) {
        final updatedOrders = List<OrderEntity>.from(currentState.orders);
        updatedOrders[index] = newOrder;

        emit(currentState.copyWith(orders: updatedOrders));
      }
    }
  }
}
