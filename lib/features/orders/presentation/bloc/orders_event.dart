part of 'orders_bloc.dart';

@immutable
sealed class OrdersEvent {}

class CreateOrderEvent extends OrdersEvent {
  final OrderEntity order;
  final List<OrderItem> items;

  CreateOrderEvent({required this.order, required this.items});
}

class GetOrdersEvent extends OrdersEvent {
  final String day;

  GetOrdersEvent({required this.day});
}

// getOrdersForProduct(productId)
// deleteOrder()
