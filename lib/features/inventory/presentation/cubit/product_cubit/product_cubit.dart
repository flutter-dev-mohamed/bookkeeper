import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/get_product_by_id.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/remove_product_from_archive.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductById _getProductById;
  final RemoveProductFromArchive _removeProductFromArchive;

  ProductCubit({
    required this._getProductById,
    required this._removeProductFromArchive,
  }) : super(ProductInitial());

  // get product details using product id
  void getProductDetails({
    required int productId,
    final didChange = false,
  }) async {
    emit(ProductLoading());

    OPrint.b('Getting Product...');
    final res = await _getProductById(productId);

    res.fold(
      (error) => emit(ProductFailure(message: error.message)),
      (product) =>
          emit(GotProductDetails(product: product, didChange: didChange)),
    );
  }

  void removeProductFromArchive() async {
    final currentState = state;

    if (currentState is! GotProductDetails) return;

    // this is to show loading
    emit(
      GotProductDetails(
        product: currentState.product,
        didChange: null,
        isSubmitting: true,
      ),
    );

    final res = await _removeProductFromArchive(currentState.product.id);

    res.fold(
      (error) => emit(ProductFailure(message: error.message)),
      (_) => emit(ProductUnarchived()),
    );
  }
}
