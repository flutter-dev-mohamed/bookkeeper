part of 'products_bloc.dart';

@immutable
sealed class ProductsEvent {}

class LoadProductsEvent extends ProductsEvent {}

class AddProductEvent extends ProductsEvent {
  final Product product;

  AddProductEvent({required this.product});
}
