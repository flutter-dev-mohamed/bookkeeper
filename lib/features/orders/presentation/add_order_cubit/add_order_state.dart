part of 'add_order_cubit.dart';

@immutable
sealed class AddOrderState {}

class AddOrderInitial extends AddOrderState {}

class AddOrderLoading extends AddOrderState {}

class AddOrderLoaded extends AddOrderState {
  final List<Product> productsInStock;
  final List<OrderItem> orderItems;
  final bool isSubmitting;

  AddOrderLoaded({
    required this.productsInStock,
    required this.orderItems,
    this.isSubmitting = false,
  });

  /// Returns in-stock products that have not yet been added to the order.
  ///
  /// Excludes products whose IDs already appear in [orderItems], preventing
  /// the same product from being selected more than once.
  List<Product> get availableProducts {
    final selectedIds = orderItems.map((item) => item.productId).toSet();

    return productsInStock
        .where((product) => !selectedIds.contains(product.id))
        .toList();
  }

  AddOrderLoaded copyWith({
    List<Product>? productsInStock,
    List<OrderItem>? orderItems,
    bool? isSubmitting,
  }) {
    return AddOrderLoaded(
      productsInStock: productsInStock ?? this.productsInStock,
      orderItems: orderItems ?? this.orderItems,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

/// Emitted when the order creation succeeds.
///
/// Bloc listener should:
/// return the resulting `[orderId]` via `Navigator.pop`
/// and close the current screen:
/// ```dart
/// Navigator.of(context).pop(state.orderId);
/// ```
final class NewOrderAdded extends AddOrderState {
  final int orderId;

  NewOrderAdded({required this.orderId});
}

final class AddOrdersFailure extends AddOrderState {
  final String message;

  AddOrdersFailure({required this.message});
}
