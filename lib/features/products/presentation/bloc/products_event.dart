part of 'products_bloc.dart';

@immutable
sealed class ProductsEvent {}

class LoadProductsEvent extends ProductsEvent {}

class AddProductEvent extends ProductsEvent {
  final Product product;
  final double addedCost;

  AddProductEvent({required this.product, required this.addedCost});
}

final class InventoryChangesReceived extends ProductsEvent {
  final InventoryChanges changes;

  InventoryChangesReceived(this.changes);
}
