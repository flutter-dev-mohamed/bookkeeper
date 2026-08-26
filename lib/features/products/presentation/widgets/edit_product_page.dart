import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/pages/loading_page.dart';
import 'package:shagaf_ledger/features/products/presentation/cubit/edit_product_cubit/edit_product_cubit.dart';
import 'package:shagaf_ledger/features/products/presentation/navigation_return.dart';
import 'package:shagaf_ledger/features/products/presentation/widgets/archive_product_button.dart';
import 'package:shagaf_ledger/features/products/presentation/widgets/save_edit_button.dart';

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _noteController;
  late final TextEditingController _costController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<EditProductCubit>().initEditingState(
        product: widget.product,
      ),
    );

    _nameController = TextEditingController();
    _noteController = TextEditingController();
    _costController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    _costController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _updateStateProduct(BuildContext context, {required Product product}) {
    final Product updatedProduct = product.copyWith(
      name: _nameController.text.trim(),
      note: _noteController.text.trim(),
      purchasePrice: double.parse(_costController.text.trim()),
      sellingPrice: double.parse(_priceController.text.trim()),
    );
    context.read<EditProductCubit>().updateStateProduct(
      product: updatedProduct,
    );
    // add the text from controllers
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocConsumer<EditProductCubit, EditProductState>(
      //  ——————————————————————————————————————————————————————————————————————  listener
      listener: (context, state) {
        // populate  the controllers
        if (state is EditingProduct) {
          final product = state.product;

          _nameController.text = product.name;
          _noteController.text = product.note ?? '';
          _costController.text = product.purchasePrice.toString();
          _priceController.text = product.sellingPrice.toString();
        }

        if (state is EditProductSaved) {
          context.pop(NavigationReturn.productUpdated);
        }
        if (state is EditProductArchived) {
          context.pop(NavigationReturn.productArchived);
        }
      },

      //  ——————————————————————————————————————————————————————————————————————  builder
      builder: (context, state) {
        if (state is EditProductInitial ||
            state is EditProductSaved ||
            state is EditProductArchived) {
          return LoadingPage();
        }

        //  ————————————————————————————————————————————————————————————————————  page UI
        if (state is EditingProduct) {
          final product = state.product;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('تعديل المنتج'),
                centerTitle: true,
              ),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _productInfoCard(colors, product),
                  const SizedBox(height: 16),

                  _inventoryCard(colors, product),
                  const SizedBox(height: 24),

                  SaveEditButton(),

                  const SizedBox(height: 10),

                  ArchiveProductButton(),
                ],
              ),
            ),
          );
        }

        //  ————————————————————————————————————————————————————————————————————  in case of an error
        return ErrorPage();
      },
    );
  }

  Widget _productInfoCard(ColorScheme colors, Product product) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'معلومات المنتج',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _nameController,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: 'اسم المنتج',
                prefixIcon: Icon(Icons.inventory_2_outlined),
              ),
              onSubmitted: (_) =>
                  _updateStateProduct(context, product: product),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'ملاحظة',
                hintText: 'إضافة ملاحظة',
                prefixIcon: Icon(Icons.notes_outlined),
                alignLabelWithHint: true,
              ),
              onTapOutside: (_) =>
                  _updateStateProduct(context, product: product),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _priceField(
                    controller: _costController,
                    label: 'سعر الشراء',
                    icon: Icons.shopping_cart_outlined,
                    onSubmitted: (_) =>
                        _updateStateProduct(context, product: product),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _priceField(
                    controller: _priceController,
                    label: 'سعر البيع',
                    icon: Icons.sell_outlined,
                    onSubmitted: (_) =>
                        _updateStateProduct(context, product: product),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 19,
                  color: colors.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  'تاريخ الإنشاء:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 6),
                Text(product.createdAt.toIso8601String().split('T')[0]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _inventoryCard(ColorScheme colors, Product product) {
    final inventory = product.currentInventory;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: colors.secondaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    color: colors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),

                  const Expanded(
                    child: Text(
                      'المخزون الحالي',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Text(
                    '$inventory',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'يتم تحديث المخزون تلقائياً عند إنشاء أو إلغاء الطلبات.',
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 13),
            ),

            const SizedBox(height: 4),

            Text(
              'لذلك لا يتم تعديل المخزون من صفحة تعديل المنتج.',
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required void Function(String)? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixText: 'IQD',
      ),
      onSubmitted: onSubmitted,
      onTap: () {
        // Select all text when tapped
        controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controller.text.length,
        );
      },
    );
  }

  Product getNewProduct({required Product oldProduct}) {
    return Product(
      id: oldProduct.id,
      name: _nameController.text.trim(),
      note: _noteController.text.trim(),
      purchasePrice: double.tryParse(_costController.text.trim()) ?? 0.0,
      sellingPrice: double.tryParse(_priceController.text.trim()) ?? 0.0,

      // Inventory is deliberately preserved here.
      currentInventory: oldProduct.currentInventory,

      // Preserve the original creation date.
      createdAt: oldProduct.createdAt,
    );
  }
}
