part of 'orders_cubit.dart';

@immutable
sealed class OrdersState {}

final class OrdersInitial extends OrdersState {}

final class OrdersLoading extends OrdersState {}

final class OrdersLoaded extends OrdersState {
  final List<OrderEntity> orders;
  final DateTime dateFilter;

  OrdersLoaded({required this.orders, required this.dateFilter});

  OrdersLoaded copyWith({List<OrderEntity>? orders, DateTime? dateFilter}) =>
      OrdersLoaded(
        orders: orders ?? this.orders,
        dateFilter: dateFilter ?? this.dateFilter,
      );
}

final class OrdersFailure extends OrdersState {
  final String message;

  OrdersFailure({required this.message});
}
