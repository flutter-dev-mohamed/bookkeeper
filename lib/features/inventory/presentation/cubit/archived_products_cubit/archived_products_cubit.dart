import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/get_archived_products.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/remove_product_from_archive.dart';

part 'archived_products_state.dart';

class ArchivedProductsCubit extends Cubit<ArchivedProductsState> {
  final GetArchivedProducts _getArchivedProducts;

  ArchivedProductsCubit({required this._getArchivedProducts})
    : super(ArchivedProductsInitial()) {
    loadArchivedProducts();
  }

  void loadArchivedProducts({bool didChanged = false}) async {
    final res = await _getArchivedProducts(NoParams());

    res.fold(
      (error) => emit(
        GotArchivedProducts(
          products: [],
          hasError: true,
          errorMessage: error.message,
        ),
      ),
      (products) =>
          emit(GotArchivedProducts(products: products, didChanged: didChanged)),
    );
  }
}
