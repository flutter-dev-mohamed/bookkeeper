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
  final bool isSubmitting;

  GotProductDetails({
    required this.product,
    required this.didChange,
    this.isSubmitting = false,
  });
}

final class ProductUnarchived extends ProductState {}
