import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/functions/date_formatting.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/get_new_order.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/get_orders.dart';
import 'package:shagaf_ledger/features/orders/presentation/orders_cubit/orders_effect.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetOrders _getOrders;
  final GetNewOrder _getNewOrder;

  OrdersCubit({required this._getOrders, required this._getNewOrder})
    : super(OrdersInitial()) {
    loadOrders(dateFilter: DateTime.now());
  }

  @override
  Future<void> close() {
    _effectsController.close();
    return super.close();
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

  // in case of cancelling an order: call this function after the cancelling is succeeded
  void updateOrdersList({required OrderEntity newOrder, required int atIndex}) {
    final currentState = state;
    if (currentState is! OrdersLoaded) return;

    // ensure the item actually exists in the list for safety
    if (atIndex != -1) {
      final updatedOrders = List<OrderEntity>.from(currentState.orders);
      updatedOrders[atIndex] = newOrder;

      emit(currentState.copyWith(orders: updatedOrders));
    }
  }

  void getNewOrder({required int orderId}) async {
    final currentState = state;
    if (currentState is! OrdersLoaded) return;
    final updatedOrders = currentState.orders;

    final newOrder = await _getNewOrder(orderId);

    newOrder.fold(
      // emit last successful state
      (error) => _onFailure(error.message, currentState),

      (newOrder) {
        updatedOrders.insert(0, newOrder);
        emit(
          OrdersLoaded(
            orders: updatedOrders,
            dateFilter: currentState.dateFilter,
          ),
        );
      },
    );
  }
}
