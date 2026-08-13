part of 'orders_bloc.dart';

@immutable
sealed class OrdersEvent {}

class CreateOrderEvent extends OrdersEvent {
  final OrderEntity order;

  CreateOrderEvent({required this.order});
}

class GetOrdersEvent extends OrdersEvent {
  final DateTime day;

  GetOrdersEvent({required this.day});
}

// getOrders(DateTime day)
// getOrdersForProduct(productId)
// deleteOrder()
