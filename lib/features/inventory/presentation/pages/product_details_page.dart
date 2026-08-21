import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/app_consts.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:shagaf_ledger/features/inventory/presentation/widgets/archive_product_button.dart';

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
    context.read<InventoryBloc>().add(
      GetProductByIdEvent(productId: widget.productId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocConsumer<InventoryBloc, InventoryState>(
      listener: (context, state) {
        // in case of update or archive
        // in some cases we are in the details page but after editing or archiving a product
        // we emit InventorySuccess which will trigger a InventoryLoadProducts event
        // so we need to get the new product info from DB
        if (state is InventoryProductsLoaded) {
          context.read<InventoryBloc>().add(
            GetProductByIdEvent(productId: widget.productId),
          );
        }
      },
      builder: (context, state) {
        if (state is InventoryLoading) {
          return Center(
            child: CircularProgressIndicator(),
          ); // loading indicator
        }

        if (state is InventoryGotProductById) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('تفاصيل المنتج'),
                centerTitle: true,
              ),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _headerCard(context, state.product, colors),
                  const SizedBox(height: 16),

                  _inventoryCard(context, state.product, colors),
                  const SizedBox(height: 16),

                  _pricingCard(context, state.product, colors),
                  const SizedBox(height: 16),

                  _noteCard(context, state.product, colors),

                  const SizedBox(height: 16),

                  _createdAtCard(context, state.product, colors),

                  const SizedBox(height: 24),

                  _editButton(context, state.product),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        }

        // in case of an error
        return ErrorPage();
      },
    );
  }

  Widget _headerCard(
    BuildContext context,
    Product product,
    ColorScheme colors,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(child: Text("📦", style: TextStyle(fontSize: 34))),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.isArchived ? 'منتج مؤرشف' : 'منتج نشط',
                      style: TextStyle(
                        color: product.isArchived
                            ? Colors.orangeAccent
                            : Colors.lightGreenAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inventoryCard(
    BuildContext context,
    Product product,
    ColorScheme colors,
  ) {
    final stock = product.currentInventory;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'المخزون',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
              decoration: BoxDecoration(
                color: colors.secondaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 32,
                    color: colors.primary,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '$stock',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: (stock == 0) ? colors.error : colors.primary,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    'قطعة متوفرة',
                    style: TextStyle(
                      color: colors.onSecondaryContainer,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'يتم تحديث المخزون تلقائياً عند إنشاء أو إلغاء الطلبات.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pricingCard(
    BuildContext context,
    Product product,
    ColorScheme colors,
  ) {
    final profit = product.sellingPrice - product.purchasePrice;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الأسعار',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            _priceRow(
              context,
              icon: Icons.sell_outlined,
              label: 'سعر البيع',
              value: product.sellingPrice,
              valueColor: colors.primary,
            ),

            const Divider(height: 24),

            _priceRow(
              context,
              icon: Icons.shopping_cart_outlined,
              label: 'سعر الشراء',
              value: product.purchasePrice,
            ),

            const Divider(height: 24),

            _priceRow(
              context,
              icon: Icons.trending_up_outlined,
              label: 'الربح لكل قطعة',
              value: profit,
              valueColor: profit >= 0 ? colors.primary : colors.error,
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required double value,
    Color? valueColor,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 22, color: colors.primary),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),

        Text(
          '${_formatNumber(value)} IQD',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _noteCard(BuildContext context, Product product, ColorScheme colors) {
    if (product.note == null || product.note!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.notes_outlined),
                SizedBox(width: 8),
                Text(
                  'ملاحظة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              product.note!,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createdAtCard(
    BuildContext context,
    Product product,
    ColorScheme colors,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, color: colors.primary),

            const SizedBox(width: 12),

            const Text(
              'تاريخ إنشاء المنتج',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const Spacer(),

            Text(
              product.createdAt.toIso8601String().split('T')[0],
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _editButton(BuildContext context, Product product) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () {
          context.pushNamed(
            AppConsts().editProductPage,
            pathParameters: {"productId": product.id.toString()},
          );
        },
        icon: const Icon(Icons.edit_outlined),
        label: const Text('تعديل المنتج'),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }
}
