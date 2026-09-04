import 'package:flutter/material.dart';
import 'package:shagaf_ledger/core/common/functions/date_formatting.dart';

class CreatedAtCard extends StatelessWidget {
  final DateTime createdAt;

  const CreatedAtCard({super.key, required this.createdAt});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
              dateFormatting(createdAt),
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
