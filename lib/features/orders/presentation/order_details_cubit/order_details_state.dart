part of 'order_details_cubit.dart';

@immutable
sealed class OrderDetailsState {}

final class OrderDetailsInitial extends OrderDetailsState {}

final class OrderDetailsLoading extends OrderDetailsState {}

final class OrderDetailsSuccess extends OrderDetailsState {}

final class OrderDetailsFailure extends OrderDetailsState {
  final String message;

  OrderDetailsFailure({required this.message}) {
    OPrint.br(message);
  }
}

final class GotOrderDetails extends OrderDetailsState {
  final OrderEntity order;
  final List<OrderItem> items;

  GotOrderDetails({required this.order, required this.items});
}
