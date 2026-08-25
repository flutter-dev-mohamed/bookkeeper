import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/add_product.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/get_active_products.dart';

part 'inventory_event.dart';

part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetActiveProducts _getActiveProducts;
  final AddProduct _addProduct;

  InventoryBloc({required this._getActiveProducts, required this._addProduct})
    : super(InventoryInitial()) {
    on<InventoryEvent>((event, emit) {
      emit(InventoryLoading());
      OPrint.bg(event.toString());
    });

    on<LoadProductsEvent>(_onInventoryLoadProducts);

    on<AddProductEvent>(_onInventoryAddProduct);

    add(LoadProductsEvent());
  }

  void _onInventoryLoadProducts(
    LoadProductsEvent event,
    Emitter<InventoryState> emit,
  ) async {
    final products = await _getActiveProducts(NoParams());

    products.fold((error) => emit(InventoryFailure(message: error.message)), (
      products,
    ) {
      emit(InventoryProductsLoaded(products: products));
    });
  }

  void _onInventoryAddProduct(
    AddProductEvent event,
    Emitter<InventoryState> emit,
  ) async {
    final product = await _addProduct(event.product);

    product.fold(
      (error) => InventoryFailure(message: error.message),
      (productId) => emit(InventorySuccess()),
    );
  }
}
