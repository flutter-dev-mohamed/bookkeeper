import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/products/domain/use_cases/archive_product.dart';
import 'package:shagaf_ledger/features/products/domain/use_cases/update_product.dart';

part 'edit_product_state.dart';

class EditProductCubit extends Cubit<EditProductState> {
  final UpdateProduct _updateProduct;
  final ArchiveProduct _archiveProduct;

  EditProductCubit({
    required this._updateProduct,
    required this._archiveProduct,
  }) : super(EditProductInitial());

  void initEditingState({required Product product}) =>
      emit(EditingProduct(product: product));

  /// This will save the updated product.
  void saveUpdatedProduct() async {
    final currentState = state;
    if (currentState is! EditingProduct) return;
    final product = currentState.product;

    emit(EditingProduct(product: product, isSubmitting: true));

    final res = await _updateProduct(product);

    res.fold(
      (error) =>
          emit(EditingProduct(product: product, errorMessage: error.message)),
      (updatedProduct) {
        emit(EditProductSaved());
      },
    );
  }

  /// This function will archive the product.
  void archiveProduct() async {
    final currentState = state;
    if (currentState is! EditingProduct) return;
    final product = currentState.product;

    emit(EditingProduct(product: product, isArchiving: true));

    final res = await _archiveProduct(product.id);

    res.fold(
      (error) =>
          emit(EditingProduct(product: product, errorMessage: error.message)),
      (_) => emit(EditProductArchived()),
    );
  }

  /// The state should be the only source of truth use this function to
  /// update the product info and pass the product using Product.copyWith
  /// and only change the elements you need.
  void updateStateProduct({required Product product}) {
    emit(EditingProduct(product: product));
  }
}
