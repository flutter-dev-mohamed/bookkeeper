part of 'inventory_bloc.dart';

@immutable
sealed class InventoryEvent {}

class LoadProductsEvent extends InventoryEvent {}

class AddProductEvent extends InventoryEvent {
  final Product product;

  AddProductEvent({required this.product});
}
