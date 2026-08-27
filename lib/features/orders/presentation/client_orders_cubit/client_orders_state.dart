part of 'client_orders_cubit.dart';

@immutable
sealed class ClientOrdersState {}

final class ClientOrdersInitial extends ClientOrdersState {}

final class ClientOrdersLoading extends ClientOrdersState {}

final class ClientOrdersFailure extends ClientOrdersState {
  final String message;

  ClientOrdersFailure({required this.message});
}

final class GotClientOrders extends ClientOrdersState {
  final List<OrderEntity> orders;

  GotClientOrders({required this.orders});
}
