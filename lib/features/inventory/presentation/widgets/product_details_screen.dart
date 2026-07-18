import 'package:flutter/material.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/presentation/widgets/delete_product_button.dart';
import 'package:shagaf_ledger/features/inventory/presentation/widgets/edit_product_button.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 5,
        children: [
          const SizedBox(height: 20),
          Card(
            color: Colors.grey.shade200,
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
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (product.note != null && product.note != '')
                      Text(
                        product.note!,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    const Divider(height: 30),
                    _buildDetailRow(
                      Icons.local_offer,
                      "سعر البيع",
                      "${product.sellingPrice} د.ع",
                    ),
                    _buildDetailRow(
                      Icons.attach_money,
                      "سعر الشراء",
                      "${product.purchasePrice} د.ع",
                    ),
                    _buildDetailRow(
                      Icons.inventory,
                      "مخزون الحالي",
                      "${product.currentInventory} قطعة ",
                    ),
                    _buildDetailRow(
                      Icons.calendar_today,
                      "تاريخ الإنشاء",
                      "${product.createdAt.day}-${product.createdAt.month}-${product.createdAt.year}",
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          EditProductButton(product: product),
        ],
      ),
    );
  }
}

// Helper to keep code clean
Widget _buildDetailRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 10),
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    ),
  );
}
