part of 'orders_bloc.dart';

@immutable
sealed class OrdersEvent {}

class GetOrdersEvent extends OrdersEvent {
  final DateTime day;

  GetOrdersEvent({required this.day});
}

// getOrdersForProduct(productId)
