part of 'inventory_bloc.dart';

@immutable
sealed class InventoryState {}

final class InventoryInitial extends InventoryState {}

final class InventoryLoading extends InventoryState {}

// InventorySuccess state is emitted on add product
final class InventorySuccess extends InventoryState {}

final class InventoryFailure extends InventoryState {
  final String message;

  InventoryFailure({required this.message});
}

final class InventoryProductsLoaded extends InventoryState {
  final List<Product> products;

  InventoryProductsLoaded({required this.products});
}
