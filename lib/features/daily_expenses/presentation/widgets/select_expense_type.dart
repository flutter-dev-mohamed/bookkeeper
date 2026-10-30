import 'package:flutter/material.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/entities/expense.dart';

class SelectExpenseType extends StatelessWidget {
  final ExpenseType selectedType;
  final void Function(ExpenseType) onSelected;

  const SelectExpenseType({
    super.key,
    required this.selectedType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        Text(
          'الفئة',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: ExpenseType.values.map((type) {
            final isSelected = selectedType == type;
            return ChoiceChip(
              label: Text(type.name.toUpperCase()),
              selected: isSelected,
              selectedColor: colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (selected) {
                if (selected) onSelected(type);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
