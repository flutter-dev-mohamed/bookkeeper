import 'package:flutter/material.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/core/common/product_list.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
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
  String note = '';
  double totalPrice = 0;

  Order getOrder() {
    // return Order(
    //   id: 0,
    //   createdAt: DateTime.now(),
    //   totalPrice: totalPrice,
    //   items: orderItems,
    //   note: note,
    //  );
    // TODO: implement the getOrder func
    throw UnimplementedError();
  }

  //  ==========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 10),
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
                    onQuantityChanged: ({required index, required quantity}) =>
                        setState(() {
                          orderItems[index] = orderItems[index].copyWith(
                            quantity: quantity,
                          );
                        }),
                  );
                },
              ),
            ),

            //  ——————————————————————————————————————————————————————————————  OrderSummarySheet
            OrderSummarySheet(
              orderItems: orderItems,
              onNoteChanged: (newNote) {
                setState(() {
                  note = newNote;
                });
              },
              onContinue: () {
                OPrint.bg('add order');
                getOrder();
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
}
