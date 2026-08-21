import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/add_product.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/archive_product.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/get_product_by_id.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/get_products.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/update_product.dart';

part 'inventory_event.dart';

part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetProducts _getProducts;
  final AddProduct _addProduct;
  final UpdateProduct _updateProduct;
  final ArchiveProduct _archiveProduct;
  final GetProductById _getProductById;

  InventoryBloc({
    required this._getProducts,
    required this._addProduct,
    required this._getProductById,
    required this._updateProduct,
    required this._archiveProduct,
  }) : super(InventoryInitial()) {
    on<InventoryEvent>((event, emit) {
      emit(InventoryLoading());
      OPrint.bg(event.toString());
    });

    on<LoadProductsEvent>(_onInventoryLoadProducts);

    on<AddProductEvent>(_onInventoryAddProduct);

    on<GetProductByIdEvent>(_onGetProductByIdEvent);

    on<UpdateProductEvent>(_onUpdateProductEvent);

    on<ArchiveProductEvent>(_onArchiveProductEvent);
  }

  void _onInventoryLoadProducts(
    LoadProductsEvent event,
    Emitter<InventoryState> emit,
  ) async {
    final products = await _getProducts(NoParams());

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

  void _onGetProductByIdEvent(
    GetProductByIdEvent event,
    Emitter<InventoryState> emit,
  ) async {
    OPrint.b('Getting Product...');
    final res = await _getProductById(event.productId);

    res.fold(
      (error) => emit(InventoryFailure(message: error.message)),
      (product) => emit(InventoryGotProductById(product: product)),
    );
  }

  void _onUpdateProductEvent(
    UpdateProductEvent event,
    Emitter<InventoryState> emit,
  ) async {
    final res = await _updateProduct(event.product);

    res.fold((error) => emit(InventoryFailure(message: error.message)), (
      updatedProduct,
    ) {
      emit(InventorySuccess());
    });
  }

  void _onArchiveProductEvent(
    ArchiveProductEvent event,
    Emitter<InventoryState> emit,
  ) async {
    final res = await _archiveProduct(event.product.id);

    res.fold(
      (error) => emit(InventoryFailure(message: error.message)),
      (_) => emit(InventorySuccess()),
    );
  }
}
