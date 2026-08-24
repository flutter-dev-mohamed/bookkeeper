import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/get_product_by_id.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductById _getProductById;

  ProductCubit({required this._getProductById}) : super(ProductInitial());

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
}
