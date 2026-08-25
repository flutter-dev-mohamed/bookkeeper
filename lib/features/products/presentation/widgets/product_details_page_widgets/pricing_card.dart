import 'package:flutter/material.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';

class PricingCard extends StatelessWidget {
  final Product product;

  const PricingCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final profit = product.sellingPrice - product.purchasePrice;
    final colors = Theme.of(context).colorScheme;

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

  //  TODO: make this a common widget and use it in order details
  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }
}
