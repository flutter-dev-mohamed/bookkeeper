import 'package:flutter/material.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/presentation/widgets/inventory_widgets/delete_product_button.dart';
import 'package:shagaf_ledger/features/inventory/presentation/widgets/inventory_widgets/save_edit_button.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final product = widget.product;

    _nameController.text = product.name;
    _noteController.text = product.note ?? '';
    _costController.text = product.purchasePrice.toString();
    _priceController.text = product.sellingPrice.toString();
    _stockController.text = product.currentInventory.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    _costController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 5,
        children: [
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _nameField(), // name
                    _noteField(),
                    const Divider(height: 30),
                    _buildDetailRow(
                      Icons.local_offer,
                      "سعر البيع",
                      _priceController,
                      TextInputType.number,
                    ),
                    _buildDetailRow(
                      Icons.attach_money,
                      "سعر الشراء",
                      _costController,
                      TextInputType.number,
                    ),
                    _buildDetailRow(
                      Icons.inventory,
                      "مخزون الحالي",
                      _stockController,
                      TextInputType.number,
                    ),

                    _createdAt(),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          SaveEditButton(getProduct: getProduct),

          DeleteProductButton(product: widget.product),
        ],
      ),
    );
  }

  Widget _nameField() {
    return TextField(
      controller: _nameController,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      decoration: const InputDecoration(
        isDense: false,
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 1.3)),
        // Keeps it looking clean like a text widget
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _noteField() {
    return TextField(
      controller: _noteController,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(6),
        hintText: 'إضافة ملاحظة',
      ),
    );
  }

  Widget _createdAt() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 20, color: Colors.blue),
          const SizedBox(width: 10),
          Text(
            "تاريخ الإنشاء: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "${widget.product.createdAt.day}-${widget.product.createdAt.month}-${widget.product.createdAt.year}",
          ),
        ],
      ),
    );
  }

  //
  Product getProduct() {
    // 1. Log the raw values coming from your controllers
    OPrint.m('--- Debugging getProduct ---');
    OPrint.m('Raw Name: "${_nameController.text}"');
    OPrint.m('Raw Cost: "${_costController.text}"');
    OPrint.m('Raw Price: "${_priceController.text}"');
    OPrint.m('Raw Stock: "${_stockController.text}"');

    final product = Product(
      id: widget.product.id,
      name: _nameController.text.trim(),
      note: _noteController.text.trim(),
      purchasePrice: double.tryParse(_costController.text.trim()) ?? 0.0,
      sellingPrice: double.tryParse(_priceController.text.trim()) ?? 0.0,
      currentInventory: int.tryParse(_stockController.text.trim()) ?? 0,
      createdAt: DateTime.now(),
    );

    // 2. Log the final object using the custom toString() we just added
    OPrint.g('Resulting Product Object: $product');

    return product;
  }
}

// Helper to keep code clean
Widget _buildDetailRow(
  IconData icon,
  String label,
  TextEditingController controller,
  TextInputType? keyboardType,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            keyboardType: keyboardType,
            controller: controller,
            decoration: InputDecoration(
              //
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20, color: Colors.blue),
                  const SizedBox(width: 10),
                  Text(
                    "$label:",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              isDense: true,
              contentPadding: EdgeInsets.all(0),
            ),
          ),
        ),
      ],
    ),
  );
}
