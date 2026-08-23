import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/create_order.dart';

part 'add_order_state.dart';

class AddOrderCubit extends Cubit<AddOrderState> {
  final CreateOrder _createOrder;

  AddOrderCubit({required this._createOrder}) : super(AddOrderInitial());

  void getAvailableProducts() {
    emit(AddOrderLoading());

    // TODO: make the use case
    // I will add this don't make is
    // all you need to know is it will emit AvailableProductsLoaded
    throw UnimplementedError();
  }

  void addOrder({
    required OrderEntity order,
    required List<OrderItem> items,
  }) async {
    final currentState = state;

    if (currentState is! AddOrderLoaded) return;

    emit(currentState.copyWith(isSubmitting: true));
    final res = await _createOrder(
      CreateOrderParams(order: order, items: items),
    );

    res.fold(
      (error) => emit(
        currentState.copyWith(isSubmitting: false, errorMessage: error.message),
      ),
      (_) => emit(NewOrderAdded()),
    );
  }

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
