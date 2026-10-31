import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shagaf_ledger/core/common/functions/date_formatting.dart';
import 'package:shagaf_ledger/core/common/functions/price_formate.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/entities/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final Function(Expense)? onEdit;
  final VoidCallback? onDelete;

  const ExpenseTile({
    super.key,
    required this.expense,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Slidable(
      // ——————————————————————————————————————————————————————————————————— Left to Right (Edit)
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onEdit?.call(),
            backgroundColor: theme.colorScheme.secondaryContainer,
            foregroundColor: theme.colorScheme.onSecondaryContainer,
            icon: Icons.edit_rounded,
            label: 'Edit',
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(12),
              left: Radius.circular(12),
            ),
          ),
        ],
      ),

      // ——————————————————————————————————————————————————————————————————— Right to Left (Delete)
      endActionPane: ActionPane(
        dragDismissible: true,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onDelete?.call(),
            backgroundColor: theme.colorScheme.errorContainer,
            foregroundColor: theme.colorScheme.onErrorContainer,
            icon: Icons.delete_rounded,
            label: 'Delete',
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(12),
              left: Radius.circular(12),
            ),
          ),
        ],
      ),

      // ——————————————————————————————————————————————————————————————————— Tile Body
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
        ),
        child: ListTile(
          title: Column(
            children: [
              Row(
                children: [
                  // ——————————————————————————————————————————————————————————— amount
                  Text(
                    priceFormate(expense.amount),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(width: 6),

                  // ——————————————————————————————————————————————————————————— type
                  SizedBox(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        expense.type.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    dateFormatting(DateTime.parse(expense.createdAt)),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          subtitle: (expense.note.trim().isNotEmpty)
              ? Text(expense.note, style: theme.textTheme.bodySmall)
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
