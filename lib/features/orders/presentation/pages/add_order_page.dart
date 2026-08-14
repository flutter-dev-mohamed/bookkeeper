import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/core/common/product_list.dart';
import 'package:shagaf_ledger/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
import 'package:shagaf_ledger/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/order_item_dropdown_menu.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/order_summary_sheet.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/selected_order_item_tile.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  //  a list of all available products
  List<Product> availableProducts = products.where((product) {
    if (product.currentInventory > 0) {
      return true;
    }
    return false;
  }).toList();

  //  order params
  List<OrderItem> orderItems = [];
  double totalPrice = 0;

  //  ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إضافة طلب',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: availableProducts.isEmpty && orderItems.isEmpty
          // indicate no products
          ? Center(
              child: Text(
                "يرجى اضافة منتجات!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            )
          : Directionality(
              textDirection: TextDirection.rtl,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 120),
                      itemCount: orderItems.length + 1,
                      itemBuilder: (context, index) {
                        // show add order item at the end of the list
                        if (index == orderItems.length || orderItems.isEmpty) {
                          return OrderItemDropdownMenu(
                            onChanged: onSelectedNewItem,
                            availableProducts: availableProducts,
                          );
                        }

                        //
                        return SelectedOrderItemTile(
                          index: index,
                          initialItem: orderItems[index],
                          availableProducts: availableProducts,
                          onChangedSelection: onChangedSelection,
                          onDelete: onDelete,
                          onQuantityChanged:
                              ({required index, required quantity}) =>
                                  setState(() {
                                    orderItems[index] = orderItems[index]
                                        .copyWith(quantity: quantity);
                                  }),
                        );
                      },
                    ),
                  ),

                  //  ————————————————————————————————————————————————————————————————  OrderSummarySheet
                  BlocConsumer<OrdersBloc, OrdersState>(
                    listener: (context, state) {
                      if (state is OrdersFailer) {
                        // alert use in case of error
                        showOrderErrorDialog(context);
                      }
                      if (state is OrderCreated) {
                        // communicate to the inventory bloc to  reflect the changes
                        context.read<InventoryBloc>().add(LoadProductsEvent());
                        // pop the add order page
                        context.pop();
                      }
                    },
                    builder: (context, state) {
                      return OrderSummarySheet(
                        isLoading: state is OrdersLoading,
                        orderItems: orderItems,
                        //  ———————————————————————————————————————————————————— this will run when pressed continue
                        onContinue:
                            ({
                              required discountType,
                              required discountValue,
                              required noteText,
                            }) {
                              context.read<OrdersBloc>().add(
                                CreateOrderEvent(
                                  order: OrderEntity(
                                    id: 0,
                                    note: noteText,
                                    discountType: discountType,
                                    discountValue: discountValue,
                                    createdAt: DateTime.now()
                                        .toIso8601String()
                                        .split('T')[0],
                                    totalPrice: totalPrice,
                                  ),
                                  items: orderItems,
                                ),
                              );
                            },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  //  ——————————————————————————————————————————————————————————————————————————  change selected item func
  void onChangedSelection({
    required Product oldProduct,
    required Product newProduct,
    required int index,
  }) {
    setState(() {
      availableProducts.add(oldProduct);
      availableProducts.remove(newProduct);

      final currentQuantity = orderItems[index].quantity;

      final newQuantity = currentQuantity > newProduct.currentInventory
          ? newProduct.currentInventory
          : currentQuantity;

      orderItems[index] = orderItems[index].copyWith(
        productId: newProduct.id,
        productName: newProduct.name,
        unitSellingPrice: newProduct.sellingPrice,
        quantity: newQuantity,
      );
    });
  }

  //  ——————————————————————————————————————————————————————————————————————————  select new item func
  void onSelectedNewItem(Product? selectedProduct) {
    OPrint.bb('you selected ${selectedProduct?.name}');
    if (selectedProduct != null) {
      setState(() {
        //  remove product from available products list
        availableProducts.remove(selectedProduct);

        // add order item
        orderItems.add(
          OrderItem(
            id: orderItems.length,
            orderId: 0,
            productId: selectedProduct.id,
            productName: selectedProduct.name,
            quantity: 1,
            unitSellingPrice: selectedProduct.sellingPrice,
          ),
        );
      });
    }
  }

  //  ——————————————————————————————————————————————————————————————————————————   on delete
  void onDelete(int index) {
    setState(() {
      final deletedProduct = products.firstWhere((product) {
        return product.id == orderItems[index].productId;
      });
      orderItems.removeAt(index);
      availableProducts.add(deletedProduct);
    });
  }

  //  ——————————————————————————————————————————————————————————————————————————   show Order Error Dialog
  void showOrderErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shadowColor: colorScheme.shadow,
          title: Text(
            'Error',
            style: TextStyle(
              color: colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'There was an error saving or adding your order into the database. Please try again.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              // Note: If you are using GoRouter, you can use context.pop() instead
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }
}
