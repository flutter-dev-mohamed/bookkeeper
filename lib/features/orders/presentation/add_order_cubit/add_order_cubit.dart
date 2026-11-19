import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/app_notifications/app_notifications.dart';
import 'package:shagaf_ledger/core/app_notifications/notifications/inventory_changes.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/orders/presentation/add_order_cubit/add_order_effect.dart';
import 'package:shagaf_ledger/features/products/domain/use_cases/get_active_products.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/create_order.dart';

part 'add_order_state.dart';

class AddOrderCubit extends Cubit<AddOrderState> {
  /// `TODO:` send an [`InventoryChanges`] [`AppNotification`]
  final CreateOrder _createOrder;
  final GetActiveProducts _getActiveProducts;
  final AppNotifications _appNotifications;

  AddOrderCubit({
    required this._createOrder,
    required this._getActiveProducts,
    required this._appNotifications,
  }) : super(AddOrderInitial()) {
    // get the active available products
    getActiveProducts();
  }

  @override
  Future<void> close() {
    _effectsController.close();
    return super.close();
  }

  final _effectsController = StreamController<AddOrderEffect>.broadcast();

  Stream<AddOrderEffect> get effects => _effectsController.stream;

  void getActiveProducts() async {
    emit(AddOrderLoading());

    final res = await _getActiveProducts(NoParams());

    res.fold(
      (error) => emit(AddOrdersFailure(message: error.message)),
      (productsList) => emit(
        AddOrderLoaded(
          productsInStock: productsList
              .where((product) => product.currentInventory > 0)
              .toList(),
          orderItems: [],
        ),
      ),
    );
  }

  void addOrder({
    required OrderEntity order,
    required List<OrderItem> items,
  }) async {
    final currentState = state;

    if (currentState is! AddOrderLoaded) return;

    emit(currentState.copyWith(isSubmitting: true));

    await Future.delayed(Duration(seconds: 6));

    final res = await _createOrder(
      CreateOrderParams(order: order, items: items),
    );

    res.fold(
      // if failed
      (error) {
        // restore last stable state
        emit(currentState.copyWith(isSubmitting: false));

        // add an effect to show an error dialog
        _effectsController.add(ShowAddOrderErrorDialog(message: error.message));
      },

      // if success
      (orderId) {
        _appNotifications.notifyInventoryChanged(
          InventoryChanges(
            inventoryChanges: currentState.orderItems.map((item) {
              return InventoryChange(
                productId: item.productId,
                quantity: item.quantity,
                changeType: InventoryChangeType.subtract,
              );
            }).toList(),
          ),
        );
        emit(NewOrderAdded(orderId: orderId));
      },
    );
  }

  // ———————————————————————————————————————————————————————————————————————————  UI control methods
  void selectProduct(Product product) {
    final currentState = state;

    if (currentState is! AddOrderLoaded) return;

    final updatedItems = List<OrderItem>.from(currentState.orderItems);

    updatedItems.add(
      OrderItem(
        id: updatedItems.length,
        orderId: 0,
        productId: product.id,
        productName: product.name,
        quantity: 1,
        unitSellingPrice: product.sellingPrice,
      ),
    );

    emit(
      AddOrderLoaded(
        productsInStock: currentState.productsInStock,
        orderItems: updatedItems,
      ),
    );
  }

  void changeSelectedProduct({
    required int index,
    required Product newProduct,
  }) {
    final currentState = state;

    if (currentState is! AddOrderLoaded) return;

    final updatedItems = List<OrderItem>.from(currentState.orderItems);

    final oldItem = updatedItems[index];

    final newQuantity = oldItem.quantity > newProduct.currentInventory
        ? newProduct.currentInventory
        : oldItem.quantity;

    updatedItems[index] = oldItem.copyWith(
      productId: newProduct.id,
      productName: newProduct.name,
      unitSellingPrice: newProduct.sellingPrice,
      quantity: newQuantity,
    );

    emit(
      AddOrderLoaded(
        productsInStock: currentState.productsInStock,
        orderItems: updatedItems,
      ),
    );
  }

  void deleteOrderItem(int index) {
    final currentState = state;

    if (currentState is! AddOrderLoaded) return;

    final updatedItems = List<OrderItem>.from(currentState.orderItems)
      ..removeAt(index);

    emit(
      AddOrderLoaded(
        productsInStock: currentState.productsInStock,
        orderItems: updatedItems,
      ),
    );
  }

  void changeQuantity({required int index, required int quantity}) {
    final currentState = state;

    if (currentState is! AddOrderLoaded) return;

    final updatedItems = List<OrderItem>.from(currentState.orderItems);

    updatedItems[index] = updatedItems[index].copyWith(quantity: quantity);

    emit(
      AddOrderLoaded(
        productsInStock: currentState.productsInStock,
        orderItems: updatedItems,
      ),
    );
  }
}
