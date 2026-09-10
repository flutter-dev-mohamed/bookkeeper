part of 'archived_products_cubit.dart';

@immutable
sealed class ArchivedProductsState {}

final class ArchivedProductsInitial extends ArchivedProductsState {}

final class GotArchivedProducts extends ArchivedProductsState {
  final List<Product> products;
  final bool didChanged;

  // final bool isLoading;
  final bool hasError;
  final String? errorMessage;

  GotArchivedProducts({
    required this.products,
    this.didChanged = false,
    // this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
  });
}
