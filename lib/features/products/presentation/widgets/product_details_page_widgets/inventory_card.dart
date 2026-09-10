import 'package:flutter/material.dart';

class InventoryCard extends StatelessWidget {
  final int currentInventory;

  const InventoryCard({super.key, required this.currentInventory});

  @override
  Widget build(BuildContext context) {
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
                    '$currentInventory',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: (currentInventory == 0)
                          ? colors.error
                          : colors.primary,
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
}
