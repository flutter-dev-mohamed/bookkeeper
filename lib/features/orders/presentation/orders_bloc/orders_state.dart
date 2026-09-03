part of 'orders_bloc.dart';

@immutable
sealed class OrdersState {}

final class OrdersInitial extends OrdersState {}

final class OrdersLoading extends OrdersState {}

final class OrdersUpdating extends OrdersState {}

final class OrdersLoaded extends OrdersState {
  final DateTime dateFilter;
  final List<OrderEntity> orders;

  OrdersLoaded({required this.orders, required this.dateFilter});
}

// TODO: MAKE IT SO THAT WHEN AN ERROR OCCURS THIS SHOWS AN ALERT DIALECT
final class OrdersFailer extends OrdersState {
  final String message;

  OrdersFailer({required this.message}) {
    OPrint.lineC("OrdersFailer");
    OPrint.br(message);
    OPrint.lineC("OrdersFailer");
  }
}
