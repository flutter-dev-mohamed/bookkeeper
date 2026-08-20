import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/Order_details.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/create_order.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/delete_order.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/get_order_details.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/get_orders.dart';

part 'orders_event.dart';

part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final CreateOrder _createOrder;
  final GetOrders _getOrders;
  final GetOrderDetails _getOrderDetails;
  final DeleteOrder _deleteOrder;

  OrdersBloc({
    required this._createOrder,
    required this._getOrders,
    required this._getOrderDetails,
    required this._deleteOrder,
  }) : super(OrdersInitial()) {
    on<OrdersEvent>((event, emit) {
      OPrint.m(event.toString());
      emit(OrdersLoading());
    });

    on<GetOrdersEvent>(_onGetOrderEvent);

    on<CreateOrderEvent>(_onCreateOrderEvent);

    on<GetOrderDetailsEvent>(_onGetOrderDetails);

    on<DeleteOrderEvent>(_onDeleteOrderEvent);
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
      (r) => emit(OrderCreated()),
    );
  }

  void _onGetOrderEvent(GetOrdersEvent event, Emitter<OrdersState> emit) async {
    final orders = await _getOrders(event.day);

    orders.fold(
      (error) => emit(OrdersFailer(message: error.message)),
      (orders) => emit(OrdersLoaded(orders: orders)),
    );
  }

  void _onGetOrderDetails(
    GetOrderDetailsEvent event,
    Emitter<OrdersState> emit,
  ) async {
    final orderDetails = await _getOrderDetails(event.orderId);

    orderDetails.fold(
      (error) => emit(OrdersFailer(message: error.message)),
      (details) => emit(
        OrdersGotOrderDetails(order: details.order, items: details.items),
      ),
    );
  }

  void _onDeleteOrderEvent(
    DeleteOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    final res = await _deleteOrder(event.orderDetails);

    res.fold(
      (error) => emit(OrdersFailer(message: error.message)),
      (details) => emit(OrdersSuccess()),
    );
  }
}
