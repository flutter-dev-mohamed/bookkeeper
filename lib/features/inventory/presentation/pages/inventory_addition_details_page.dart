import 'package:flutter/material.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/inventory_addition.dart';

class InventoryAdditionDetailsPage extends StatelessWidget {
  final InventoryAddition addition;

  const InventoryAdditionDetailsPage({super.key, required this.addition});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final totalSellingValue = addition.quantity * addition.unitSellingPrice;

    final expectedProfit = totalSellingValue - addition.totalPrice;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(),

        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            // ————————————————————————————————————————————————————————————————— Addition number and date
            Text(
              'إضافة رقم ${addition.id}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            Text(
              addition.createdAt,
              style: TextStyle(color: colorScheme.secondary),
            ),

            const SizedBox(height: 20),

            // ————————————————————————————————————————————————————————————————— Addition details
            _detailsCard(context, colorScheme),

            // ————————————————————————————————————————————————————————————————— Note
            if (addition.note.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ملاحظة',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      addition.note,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 8),

            Divider(height: 5, color: colorScheme.secondary),

            const SizedBox(height: 12),

            // ————————————————————————————————————————————————————————————————— Total cost
            const Text(
              'إجمالي تكلفة الإضافة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 4),

            Text(
              'IQD ${addition.totalPrice}',
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            // ————————————————————————————————————————————————————————————————— Expected selling value
            _summaryRow(title: 'قيمة البيع المتوقعة', value: totalSellingValue),

            const SizedBox(height: 8),

            // ————————————————————————————————————————————————————————————————— Expected profit
            _summaryRow(title: 'الربح المتوقع', value: expectedProfit),
          ],
        ),
      ),
    );
  }

  // ——————————————————————————————————————————————————————————————————————————— Details card
  Widget _detailsCard(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        children: [
          _detailRow(title: 'الكمية المضافة', value: '${addition.quantity}'),

          const SizedBox(height: 12),

          _detailRow(
            title: 'سعر شراء الوحدة',
            value: 'IQD ${addition.unitPurchasePrice}',
          ),

          const SizedBox(height: 12),

          _detailRow(
            title: 'سعر بيع الوحدة',
            value: 'IQD ${addition.unitSellingPrice}',
          ),
        ],
      ),
    );
  }

  // ——————————————————————————————————————————————————————————————————————————— Detail row
  Widget _detailRow({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),

        Text(
          value,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // ——————————————————————————————————————————————————————————————————————————— Summary row
  Widget _summaryRow({required String title, required double value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),

        Text(
          'IQD $value',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
