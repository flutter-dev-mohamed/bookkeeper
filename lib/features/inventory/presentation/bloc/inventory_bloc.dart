import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/add_product.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/delete_product.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/get_product_by_id.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/get_products.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/update_product.dart';

part 'inventory_event.dart';

part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetProducts _getProducts;
  final AddProduct _addProduct;
  final UpdateProduct _updateProduct;
  final DeleteProduct _deleteProduct;
  final GetProductById _getProductById;

  InventoryBloc({
    required GetProducts getProducts,
    required AddProduct addProduct,
    required GetProductById getProductById,
    required UpdateProduct updateProduct,
    required DeleteProduct deleteProduct,
  }) : _getProducts = getProducts,
       _addProduct = addProduct,
       _updateProduct = updateProduct,
       _deleteProduct = deleteProduct,
       _getProductById = getProductById,
       super(InventoryInitial()) {
    on<InventoryEvent>((event, emit) {
      OPrint.bg(event.toString());
    });

    on<LoadProductsEvent>(_onInventoryLoadProducts);

    on<AddProductEvent>(_onInventoryAddProduct);

    on<GetProductByIdEvent>(_onGetProductByIdEvent);

    on<EditProductEvent>(_onEditProductEvent);

    on<UpdateProductEvent>(_onUpdateProductEvent);

    on<DeleteProductEvent>(_onDeleteProductEvent);
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
    emit(InventoryLoading());

    final product = await _addProduct(event.product);

    product.fold(
      (error) => InventoryFailure(message: error.message),
      (productId) => emit(InventoryProductAdded(productId: productId)),
    );
  }

  void _onGetProductByIdEvent(
    GetProductByIdEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());

    OPrint.b('Getting Product...');
    final res = await _getProductById(event.productId);

    res.fold(
      (error) => emit(InventoryFailure(message: error.message)),
      (product) => emit(InventoryGotProductById(product: product)),
    );
  }

  // this method is used to put the app in the editing sate
  void _onEditProductEvent(
    EditProductEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryEditProduct(product: event.product));
    OPrint.c('App in editing state!');
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
      emit(InventoryGotProductById(product: updatedProduct));
    });
  }

  void _onDeleteProductEvent(
    DeleteProductEvent event,
    Emitter<InventoryState> emit,
  ) async {
    final res = await _deleteProduct(event.product.id);

    res.fold(
      (error) => emit(InventoryFailure(message: error.message)),
      (_) => emit(InventorySuccess()),
    );
  }
}
