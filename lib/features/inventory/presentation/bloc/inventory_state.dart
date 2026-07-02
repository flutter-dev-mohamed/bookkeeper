part of 'inventory_bloc.dart';

@immutable
sealed class InventoryState {}

final class InventoryInitial extends InventoryState {}

final class InventoryLoading extends InventoryState {}

final class InventorySuccess extends InventoryState {}

final class InventoryProductsLoaded extends InventoryState {
  final List<Product> products;

  InventoryProductsLoaded({required this.products});
}

final class InventoryProductAdded extends InventoryState {
  final int productId;

  InventoryProductAdded({required this.productId});
}

final class InventoryGotProductById extends InventoryState {
  final Product product;

  InventoryGotProductById({required this.product});
}

final class InventoryFailure extends InventoryState {
  final String message;

  InventoryFailure({required this.message});
}
