part of 'add_order_cubit.dart';

@immutable
sealed class AddOrderState {}

class AddOrderInitial extends AddOrderState {}

class AddOrderLoading extends AddOrderState {}

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

final class NewOrderAdded extends AddOrderState {}
