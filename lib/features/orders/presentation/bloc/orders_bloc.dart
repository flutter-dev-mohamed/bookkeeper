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
  final CreateOrder _createOrder;
  final GetOrders _getOrders;

  OrdersBloc({required this._createOrder, required this._getOrders})
    : super(OrdersInitial()) {
    on<OrdersEvent>((event, emit) {
      OPrint.m(event.toString());
      emit(OrdersLoading());
    });

    on<GetOrdersEvent>(_onGetOrdersEvent);

    on<CreateOrderEvent>(_onCreateOrderEvent);
  }

  void _onCreateOrderEvent(
    CreateOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    final res = await _createOrder(
      CreateOrderParams(order: event.order, items: event.items),
    );

    res.fold(
      (error) => emit(OrdersFailer(message: error.message)),
      (r) => emit(OrdersSuccess()),
    );
  }

  void _onGetOrdersEvent(
    GetOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    final orders = await _getOrders(event.day);

    orders.fold(
      (error) => emit(OrdersFailer(message: error.message)),
      (orders) => emit(
        OrdersLoaded(orders: orders, dateFilter: DateTime.parse(event.day)),
      ),
    );
  }
}
