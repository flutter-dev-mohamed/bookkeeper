part of 'products_bloc.dart';

// TODO: RENAME TO Products
@immutable
sealed class ProductsState {}

final class InventoryInitial extends ProductsState {}

final class InventoryLoading extends ProductsState {}

// InventorySuccess state is emitted on add product
final class InventorySuccess extends ProductsState {}

final class InventoryFailure extends ProductsState {
  final String message;

  InventoryFailure({required this.message});
}

final class InventoryProductsLoaded extends ProductsState {
  final List<Product> products;

  InventoryProductsLoaded({required this.products});
}
