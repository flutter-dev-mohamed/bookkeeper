part of 'orders_bloc.dart';

@immutable
sealed class OrdersEvent {}

class GetOrdersEvent extends OrdersEvent {
  final DateTime day;

  GetOrdersEvent({required this.day});
}

/// Use this event when you want to update the orders list
/// this event will keep the current date filter for the orders,
/// and will emit an UpdatingOrders state momentarily
class UpdateOrdersEvent extends OrdersEvent {}

// getOrdersForProduct(productId)
