import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/pages/loading_page.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_app_bar.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
import 'package:shagaf_ledger/features/orders/presentation/add_order_cubit/add_order_cubit.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/order_item_dropdown_menu.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/order_summary_sheet.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/selected_order_item_tile.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  @override
  void initState() {
    if (context.mounted) {
      context.read<AddOrderCubit>().getActiveProducts();
    }

    super.initState();
  }

  //  ==========================================================================

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddOrderCubit, AddOrderState>(
      listener: (context, state) {
        if (state is AddOrderLoaded) {
          if (state.errorMessage != null) {
            // alert use in case of error
            showOrderErrorDialog(context);
          }
        }

        if (state is NewOrderAdded) {
          context.pop(true);
        }
      },
      builder: (context, state) {
        //  ————————————————————————————————————————————————————————————————————  indicate loading
        if (state is AddOrderLoading) {
          return LoadingPage();
        }

        if (state is NewOrderAdded) {
          return LoadingPage();
        }

        //  ————————————————————————————————————————————————————————————————————  page UI
        if (state is AddOrderLoaded) {
          final availableProducts = state.availableProducts;
          final orderItems = state.orderItems;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: CustomAppBar(
                title: Text(
                  'إضافة طلب',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),

              body: availableProducts.isEmpty && orderItems.isEmpty
                  // indicate no products
                  ? Center(
                      child: Text(
                        "يرجى اضافة منتجات!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10),
                            shrinkWrap: true,
                            padding: EdgeInsets.only(bottom: 120, top: 20),
                            itemCount: orderItems.length + 1,
                            itemBuilder: (context, index) {
                              // show add order item at the end of the list
                              if (index == orderItems.length ||
                                  orderItems.isEmpty) {
                                return OrderItemDropdownMenu(
                                  availableProducts: availableProducts,
                                  onChanged: (product) => (product != null)
                                      ? context
                                            .read<AddOrderCubit>()
                                            .selectProduct(product)
                                      : null,
                                );
                              }

                              //
                              return SelectedOrderItemTile(
                                index: index,
                                initialItem: orderItems[index],
                                availableProducts: availableProducts,
                                initProduct: state.productsInStock.firstWhere(
                                  (product) =>
                                      product.id == orderItems[index].productId,
                                ),
                              );
                            },
                          ),
                        ),

                        //  ————————————————————————————————————————————————————————————————  OrderSummarySheet
                        OrderSummarySheet(
                          isLoading: state.isSubmitting,
                          orderItems: orderItems,
                          //  ———————————————————————————————————————————————————— this will run when pressed continue
                          onContinue:
                              ({
                                required totalPrice,
                                required originalPrice,
                                required discountType,
                                required discountValue,
                                required noteText,
                                clientId,
                              }) {
                                context.read<AddOrderCubit>().addOrder(
                                  order: OrderEntity(
                                    id: 0,
                                    clientId: clientId,
                                    note: noteText,
                                    discountType: discountType,
                                    discountValue: discountValue,
                                    createdAt: DateTime.now()
                                        .toIso8601String()
                                        .split('T')[0],
                                    totalPrice: totalPrice,
                                    originalPrice: originalPrice,
                                  ),
                                  items: orderItems,
                                );
                              },
                        ),
                      ],
                    ),
            ),
          );
        }

        //  ————————————————————————————————————————————————————————————————————  error
        return ErrorPage();
      },
    );
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
