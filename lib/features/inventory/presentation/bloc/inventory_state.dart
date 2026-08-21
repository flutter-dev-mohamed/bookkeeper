part of 'inventory_bloc.dart';

@immutable
sealed class InventoryState {}

final class InventoryInitial extends InventoryState {}

final class InventoryLoading extends InventoryState {}

// InventorySuccess state is emitted on:
// -  add product
// -  Update Product Event
// -  Archive Product Event
final class InventorySuccess extends InventoryState {}

final class InventoryProductsLoaded extends InventoryState {
  final List<Product> products;

  InventoryProductsLoaded({required this.products});
}

final class InventoryGotProductById extends InventoryState {
  final Product product;

  InventoryGotProductById({required this.product});
}

final class InventoryFailure extends InventoryState {
  final String message;

  InventoryFailure({required this.message});
}
