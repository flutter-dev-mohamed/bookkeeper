part of 'products_bloc.dart';

@immutable
sealed class ProductsEvent {}

class LoadProductsEvent extends ProductsEvent {}

class AddProductEvent extends ProductsEvent {
  final Product product;
  final double addedCost;

  AddProductEvent({required this.product, required this.addedCost});
}
