import 'package:flutter/material.dart';

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
              createdAt.toIso8601String().split('T')[0],
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
