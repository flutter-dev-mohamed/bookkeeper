import 'package:flutter/material.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/presentation/widgets/archive_product_button.dart';
import 'package:shagaf_ledger/features/inventory/presentation/widgets/save_edit_button.dart';

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

    final product = widget.product;

    _nameController = TextEditingController(text: product.name);
    _noteController = TextEditingController(text: product.note ?? '');
    _costController = TextEditingController(
      text: product.purchasePrice.toString(),
    );
    _priceController = TextEditingController(
      text: product.sellingPrice.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    _costController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final colors = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تعديل المنتج'), centerTitle: true),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _productInfoCard(colors, product),
            const SizedBox(height: 16),

            _inventoryCard(colors, product),
            const SizedBox(height: 24),

            SaveEditButton(
              getProduct: () {
                return getNewProduct(oldProduct: product);
              },
            ),

            const SizedBox(height: 10),

            ArchiveProductButton(productId: product.id),
          ],
        ),
      ),
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
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _priceField(
                    controller: _priceController,
                    label: 'سعر البيع',
                    icon: Icons.sell_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _priceField(
                    controller: _costController,
                    label: 'سعر الشراء',
                    icon: Icons.shopping_cart_outlined,
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
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixText: 'IQD',
      ),
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
