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

// this event is used to put the app in the editing state only
class EditProductEvent extends InventoryEvent {
  final Product product;

  EditProductEvent({required this.product});
}

// this event is used to actually update the product info
class UpdateProductEvent extends InventoryEvent {
  final Product product;

  UpdateProductEvent({required this.product});
}

class DeleteProductEvent extends InventoryEvent {
  final Product product;

  DeleteProductEvent({required this.product});
}
