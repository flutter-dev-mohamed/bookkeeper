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

class GetOrderDetailsEvent extends OrdersEvent {
  final int orderId;

  GetOrderDetailsEvent({required this.orderId});
}

class DeleteOrderEvent extends OrdersEvent {
  final OrderDetails orderDetails;

  DeleteOrderEvent({required this.orderDetails});
}

// getOrdersForProduct(productId)
