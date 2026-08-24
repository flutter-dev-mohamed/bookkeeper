part of 'edit_product_cubit.dart';

@immutable
sealed class EditProductState {}

final class EditProductInitial extends EditProductState {}

final class EditingProduct extends EditProductState {
  final Product product;
  final bool isSubmitting;
  final bool isArchiving;
  final String? errorMessage;

  EditingProduct({
    required this.product,
    this.isSubmitting = false,
    this.isArchiving = false,
    this.errorMessage,
  });

  EditingProduct copyWith({Product? product}) {
    return EditingProduct(product: product ?? this.product);
  }
}

final class EditProductSaved extends EditProductState {}

final class EditProductArchived extends EditProductState {}
