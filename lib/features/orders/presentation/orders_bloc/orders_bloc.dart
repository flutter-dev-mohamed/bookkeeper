import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/Order_details.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/create_order.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/cancel_order.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/get_order_details.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/get_orders.dart';

part 'orders_event.dart';

part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrders _getOrders;

  OrdersBloc({required this._getOrders}) : super(OrdersInitial()) {
    on<GetOrdersEvent>(_onGetOrdersEvent);

    on<UpdateOrdersEvent>(_onUpdateOrdersEvent);

    add(GetOrdersEvent(day: DateTime.now()));
  }

  void _onUpdateOrdersEvent(
    UpdateOrdersEvent event,
    Emitter<OrdersState> emit,
  ) {
    final currentState = state;

    if (currentState is! OrdersLoaded) return;

    emit(OrdersUpdating());

    add(GetOrdersEvent(day: currentState.dateFilter));
  }

  void _onGetOrdersEvent(
    GetOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());

    final dateString = event.day.toIso8601String().split('T')[0];

    final orders = await _getOrders(dateString);

    orders.fold(
      (error) => emit(OrdersFailer(message: error.message)),
      (orders) => emit(
        OrdersLoaded(
          orders: orders.reversed.toList(),
          dateFilter: DateTime.parse(dateString),
        ),
      ),
    );
  }
}
