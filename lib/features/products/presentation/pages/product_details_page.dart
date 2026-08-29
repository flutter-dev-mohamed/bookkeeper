import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/pages/loading_page.dart';
import 'package:shagaf_ledger/features/inventory/presentation/state/inventory_history_cubit/inventory_history_cubit.dart';
import 'package:shagaf_ledger/features/inventory/presentation/widgets/add_inventory_addition_button.dart';
import 'package:shagaf_ledger/features/inventory/presentation/widgets/product_additions_history_card.dart';
import 'package:shagaf_ledger/features/products/presentation/cubit/product_cubit/product_cubit.dart';
import 'package:shagaf_ledger/features/products/presentation/widgets/product_details_page_widgets/created_at_card.dart';
import 'package:shagaf_ledger/features/products/presentation/widgets/product_details_page_widgets/edit_button.dart';
import 'package:shagaf_ledger/features/products/presentation/widgets/product_details_page_widgets/header_card.dart';
import 'package:shagaf_ledger/features/products/presentation/widgets/product_details_page_widgets/inventory_card.dart';
import 'package:shagaf_ledger/features/products/presentation/widgets/product_details_page_widgets/note_card.dart';
import 'package:shagaf_ledger/features/products/presentation/widgets/product_details_page_widgets/pricing_card.dart';
import 'package:shagaf_ledger/features/products/presentation/widgets/product_details_page_widgets/unarchive_product_button.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  void initState() {
    // fetch the product
    context.read<ProductCubit>().getProductDetails(productId: widget.productId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is ProductUnarchived) {
          context.pop(true);
        }
      },

      builder: (context, state) {
        if (state is ProductLoading || state is ProductUnarchived) {
          return LoadingPage(); // loading indicator
        }

        if (state is GotProductDetails) {
          //  ——————————————————————————————————————————————————————————————————  Page UI
          final product = state.product;

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;

              // on popping this page this will return true if the product has changed else return false
              context.pop(state.didChange);
            },
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'تفاصيل المنتج',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                  centerTitle: true,
                  actions: [
                    if (!product.isArchived) EditButton(product: product),
                  ],
                ),
                body: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    HeaderCard(product: product),
                    const SizedBox(height: 16),

                    InventoryCard(currentInventory: product.currentInventory),
                    const SizedBox(height: 16),

                    PricingCard(product: product),
                    const SizedBox(height: 16),

                    NoteCard(note: product.note),

                    const SizedBox(height: 16),

                    CreatedAtCard(createdAt: product.createdAt),

                    const SizedBox(height: 24),

                    if (!product.isArchived)
                      AddInventoryAdditionButton(
                        productId: product.id,
                        productName: product.name,
                        onInventoryAdditionAdded: () {
                          context.read<ProductCubit>().getProductDetails(
                            productId: product.id,
                            didChange: true,
                          );
                          context
                              .read<InventoryHistoryCubit>()
                              .getProductAdditions(productId: product.id);
                        },
                      ),

                    if (product.isArchived)
                      UnarchiveProductButton(productId: product.id),

                    const SizedBox(height: 16),
                    ProductAdditionsHistoryCard(productId: product.id),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        }

        // in case of an error
        return ErrorPage();
      },
    );
  }
}
