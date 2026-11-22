import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_form_filed.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/entities/expense.dart';
import 'package:shagaf_ledger/features/daily_expenses/presentation/state_management/add_expense/add_expense_cubit.dart';
import 'package:shagaf_ledger/features/daily_expenses/presentation/state_management/add_expense/add_expense_cubit.dart';
import 'package:shagaf_ledger/features/daily_expenses/presentation/widgets/expense_type_selector.dart';

class ModalBottomSheetPage<T> extends Page<T> {
  final Widget child;
  final bool isScrollControlled;
  final bool useSafeArea;
  final Color? backgroundColor;
  final Color? barrierColor;

  const ModalBottomSheetPage({
    super.key,
    required this.child,
    this.isScrollControlled = true,
    this.useSafeArea = true,
    this.backgroundColor = Colors.transparent,
    this.barrierColor,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute<T>(
      settings: this,
      builder: (context) => child,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      backgroundColor: backgroundColor,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      modalBarrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.3),
    );
  }
}

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet({super.key});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;

  late final TextEditingController _noteController;

  @override
  void initState() {
    _amountController = TextEditingController();
    _noteController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text.trim());
    final note = _noteController.text.trim();

    context.read<AddExpenseCubit>().addExpense();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return BlocConsumer<AddExpenseCubit, AddExpenseState>(
      listener: (context, state) {
        if (state is AddExpenseSuccess) context.pop();
      },
      builder: (context, state) {
        return DraggableScrollableSheet(
          initialChildSize: 0.95,
          minChildSize: 0.65,
          maxChildSize: 0.95,
          snap: true,
          snapSizes: const [0.65, 0.85, 0.95],
          builder: (context, scrollController) => ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border(top: BorderSide(color: colorScheme.primary)),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                      spreadRadius: 2,
                      color: Colors.black.withValues(alpha: 0.15),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.fromLTRB(12, 24, 12, 24 + bottomInset),
                    children: [
                      Text(
                        'Add Expense',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),

                      //  ——————————————————————————————————————————————————————————  Type
                      ExpenseTypeSelector(),
                      const SizedBox(height: 12),

                      //  ——————————————————————————————————————————————————————————  Amount
                      CustomFormField(
                        controller: _amountController,
                        autofocus: true,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textInputAction: TextInputAction.next,
                        label: 'Amount',
                        validator: (value) {
                          final parsed = double.tryParse(value?.trim() ?? '');
                          if (parsed == null || parsed <= 0) {
                            return 'Enter a valid amount greater than 0';
                          }

                          // update the state
                          context.read<AddExpenseCubit>().updateState(
                            amount: parsed,
                          );
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      //  ——————————————————————————————————————————————————————————  Optional Note
                      CustomFormField(
                        controller: _noteController,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (note) => context
                            .read<AddExpenseCubit>()
                            .updateState(note: note.trim()),
                        label: 'Note (optional)',
                      ),
                      const SizedBox(height: 20),

                      CustomPrimaryButton(
                        text: state is AddExpenseLoading
                            ? 'Saving Expense...'
                            : 'Save Expense',
                        onPressed: () => _submit(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
