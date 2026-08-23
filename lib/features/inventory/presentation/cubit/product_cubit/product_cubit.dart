import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/archive_product.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/get_product_by_id.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/update_product.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductById _getProductById;
  final UpdateProduct _updateProduct;
  final ArchiveProduct _archiveProduct;

  ProductCubit({
    required this._getProductById,
    required this._updateProduct,
    required this._archiveProduct,
  }) : super(ProductInitial());

  // get product details using product id
  void getProductDetails({required int productId}) async {
    emit(ProductLoading());

    OPrint.b('Getting Product...');
    final res = await _getProductById(productId);

    res.fold(
      (error) => emit(ProductFailure(message: error.message)),
      (product) => emit(GotProductDetails(product: product)),
    );
  }

  // update product (Product)
  void updateProduct({required Product product}) async {
    emit(ProductLoading());

    final res = await _updateProduct(product);

    res.fold((error) => emit(ProductFailure(message: error.message)), (
      updatedProduct,
    ) {
      emit(ProductUpdated());
    });
  }

  void archiveProduct({required int productId}) async {
    emit(ProductLoading());

    final res = await _archiveProduct(productId);

    res.fold(
      (error) => emit(ProductFailure(message: error.message)),
      (_) => emit(ProductArchived()),
    );
  }
}
