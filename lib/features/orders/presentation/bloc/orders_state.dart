part of 'orders_bloc.dart';

@immutable
sealed class OrdersState {}

final class OrdersInitial extends OrdersState {}

final class OrdersLoading extends OrdersState {}

final class OrdersLoaded extends OrdersState {
  final List<OrderEntity> orders;

  OrdersLoaded({required this.orders});
}

// this is only used when an order's deleted
final class OrdersSuccess extends OrdersState {}

final class OrderCreated extends OrdersState {}

final class OrdersFailer extends OrdersState {
  final String message;

  OrdersFailer({required this.message}) {
    OPrint.br(message);
  }
}

final class OrdersGotOrderDetails extends OrdersState {
  final OrderEntity order;
  final List<OrderItem> items;

  OrdersGotOrderDetails({required this.order, required this.items});
}
