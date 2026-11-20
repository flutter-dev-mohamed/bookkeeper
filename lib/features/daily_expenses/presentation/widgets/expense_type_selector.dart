import 'package:animated_segmented_tab_control_plus/animated_segmented_tab_control_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/entities/expense.dart';
import 'package:shagaf_ledger/features/daily_expenses/presentation/state_management/add_expense/add_expense_cubit.dart';

class ExpenseTypeSelector extends StatefulWidget {
  const ExpenseTypeSelector({super.key});

  @override
  State<ExpenseTypeSelector> createState() => _ExpenseTypeSelectorState();
}

class _ExpenseTypeSelectorState extends State<ExpenseTypeSelector>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: ExpenseType.values.length,
      vsync: this,
      initialIndex: ExpenseType.transport.index,
    );
    _tabController.addListener(_onTabChanged);

    super.initState();
  }

  //  ──────────────────────────────────────────────────────────────────────────  onTapChanged
  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;

    context.read<AddExpenseCubit>().updateState(
      type: ExpenseType.values[_tabController.index],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SegmentedTabControl(
      controller: _tabController,

      height: 44,

      barDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),

      indicatorDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),

      tabTextColor: Theme.of(context).colorScheme.onSurfaceVariant,

      selectedTabTextColor: Theme.of(context).colorScheme.onPrimary,

      tabs: List<SegmentTab>.generate(
        ExpenseType.values.length,
        (index) => SegmentTab(label: ExpenseType.values[index].name),
      ),
    );
  }
}
