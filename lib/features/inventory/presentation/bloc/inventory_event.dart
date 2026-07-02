part of 'inventory_bloc.dart';

@immutable
sealed class InventoryEvent {}

class LoadProductsEvent extends InventoryEvent {}

class AddProductEvent extends InventoryEvent {
  final Product product;

  AddProductEvent({required this.product});
}

class GetProductByIdEvent extends InventoryEvent {
  final int productId;

  GetProductByIdEvent({required this.productId});
}

class UpdateProductEvent extends InventoryEvent {
  final Product product;

  UpdateProductEvent({required this.product});
}

class DeleteProductEvent extends InventoryEvent {
  final Product product;

  DeleteProductEvent({required this.product});
}
