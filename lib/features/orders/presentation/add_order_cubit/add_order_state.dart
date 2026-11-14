part of 'add_order_cubit.dart';

@immutable
sealed class AddOrderState {}

class AddOrderInitial extends AddOrderState {}

class AddOrderLoading extends AddOrderState {}

//  TODO: ADD A FAILURE STATE AND EFFECTS FOR ERROR HANDLING
class AddOrderLoaded extends AddOrderState {
  final List<Product> productsInStock;
  final List<OrderItem> orderItems;
  final bool isSubmitting;
  final String? errorMessage;

  AddOrderLoaded({
    required this.productsInStock,
    required this.orderItems,
    this.isSubmitting = false,
    this.errorMessage,
  });

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
    String? errorMessage,
  }) {
    return AddOrderLoaded(
      productsInStock: productsInStock ?? this.productsInStock,
      orderItems: orderItems ?? this.orderItems,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}

/// Emitted when the order creation succeeds.
///
/// Bloc listener should:
/// ```dart
/// return
/// ```
/// `the resulting [orderId]` via `Navigator.pop`
/// and close the current screen:
/// ```dart
/// Navigator.of(context).pop(state.orderId);
/// ```
final class NewOrderAdded extends AddOrderState {
  final int orderId;

  NewOrderAdded({required this.orderId});
}
