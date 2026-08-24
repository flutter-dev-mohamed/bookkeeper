part of 'product_cubit.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductFailure extends ProductState {
  final String message;

  ProductFailure({required this.message});
}

final class GotProductDetails extends ProductState {
  final Product product;
  final didChange;

  GotProductDetails({required this.product, required this.didChange});
}

final class ProductUpdated extends ProductState {}

// emitted when a product is archived
final class ProductArchived extends ProductState {}

// final class Product extends ProductState {}
