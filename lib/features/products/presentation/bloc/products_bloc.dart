import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/app_notifications/app_notifications.dart';
import 'package:shagaf_ledger/core/app_notifications/notifications/inventory_changes.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/products/domain/use_cases/add_product.dart';
import 'package:shagaf_ledger/features/products/domain/use_cases/get_active_products.dart';

part 'products_event.dart';

part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetActiveProducts _getActiveProducts;

  // TODO: REMOVE THE ADD PRODUCT FROM HERE AND GIVE THAT PAGE ITS OWN Cubit
  final AddProduct _addProduct;
  final AppNotifications _appNotifications;

  // TODO: THIS SHOULD LISTEN TO THE APP NOTIFICATIONS AND REFLECT INVENTORY CHANGES

  ProductsBloc({
    required this._getActiveProducts,
    required this._addProduct,
    required this._appNotifications,
  }) : super(InventoryInitial()) {
    on<ProductsEvent>((event, emit) {
      // TODO: LET EACH EVENT HANDLE LOADING ON ITS OWN
      // emit(InventoryLoading());
      OPrint.bg(event.toString());
    });

    _inventoryChanges = _appNotifications.inventoryChanges.listen(
      (event) => add(InventoryChangesReceived(event)),
    );

    on<InventoryChangesReceived>(_onInventoryChangesReceived);

    on<LoadProductsEvent>(_onInventoryLoadProducts);

    on<AddProductEvent>(_onInventoryAddProduct);

    add(LoadProductsEvent());
  }

  late final StreamSubscription<InventoryChanges> _inventoryChanges;

  void _onInventoryChangesReceived(
    InventoryChangesReceived event,
    Emitter<ProductsState> emit,
  ) {
    final currentState = state;

    if (currentState is! InventoryProductsLoaded) return;

    final updatedProducts = List<Product>.from(currentState.products);

    final changeMap = {
      for (final change in event.changes.inventoryChanges)
        change.productId: (
          quantity: change.quantity,
          changeType: change.changeType,
        ),
    };

    for (var i = 0; i < updatedProducts.length; i++) {
      final product = updatedProducts[i];
      final change = changeMap[product.id];

      if (change == null) continue;

      final inventory = switch (change.changeType) {
        InventoryChangeType.addition =>
          product.currentInventory + change.quantity,
        InventoryChangeType.subtract =>
          product.currentInventory - change.quantity,
      };

      updatedProducts[i] = product.copyWith(currentInventory: inventory);
    }

    emit(InventoryProductsLoaded(products: updatedProducts));
  }

  void _onInventoryLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductsState> emit,
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
    Emitter<ProductsState> emit,
  ) async {
    final product = await _addProduct(
      AddProductParams(product: event.product, addedCost: event.addedCost),
    );

    product.fold(
      (error) => InventoryFailure(message: error.message),
      (productId) => emit(InventorySuccess()),
    );
  }

  @override
  Future<void> close() async {
    await _inventoryChanges.cancel();
    await super.close();
  }
}
