import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_app_bar.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_form_filed.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_text_field.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/entities/expense.dart';
import 'package:shagaf_ledger/features/daily_expenses/presentation/state_management/add_expense/add_expense_cubit.dart';
import 'package:shagaf_ledger/features/daily_expenses/presentation/state_management/add_expense/add_expense_cubit.dart';
import 'package:shagaf_ledger/features/daily_expenses/presentation/widgets/select_expense_type.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();

    _amountController = TextEditingController();
    _noteController = TextEditingController();

    _amountController.addListener(
      () => _updateState(
        context,
        amount: double.tryParse(_amountController.text),
      ),
    );

    _noteController.addListener(
      () => _updateState(context, note: _noteController.text),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _updateState(
    BuildContext context, {
    ExpenseType? type,
    double? amount,
    String? note,
  }) {
    context.read<AddExpenseCubit>().updateState(
      type: type,
      amount: amount,
      note: note,
    );
  }

  void _submitExpense(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final note = _noteController.text.trim();

      // TODO: Dispatch to your BLoC/Cubit or handle submission here

      context.read<AddExpenseCubit>().addExpense();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text(
            'إضافة صرفيات',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),

        // TODO: FIX THIS PAGE IT SHOWS ERROR WHEN LOADING
        body: BlocConsumer<AddExpenseCubit, AddExpenseState>(
          listener: (context, state) {
            // TODO: 1)  ON AddExpenseSuccess POP PAGE AND RETURN [TRUE]. 2) show a dialog on AddExpenseFailure and go back to init state
            if (state is AddExpenseSuccess) {
              context.pop<Expense>(state.addedExpense);
            }
          },
          builder: (context, state) {
            if (state is AddExpenseInitial) {
              final expense = state.expense;

              ExpenseType selectedType = expense.type;

              return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  children: [
                    const SizedBox(height: 16),

                    // ———————————————————————————————————————————————————————————  type
                    SelectExpenseType(
                      selectedType: selectedType,
                      onSelected: (type) => _updateState(context, type: type),
                    ),

                    const SizedBox(height: 20),

                    // ———————————————————————————————————————————————————————————  amount
                    CustomFormField(
                      controller: _amountController,
                      label: 'تكلفة',
                      prefix: const Icon(Icons.attach_money),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء ادخال قيمة';
                        }
                        if (double.tryParse(value) == null ||
                            double.parse(value) <= 0) {
                          return 'يرجى ادخال قيمة صحيحة';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // ———————————————————————————————————————————————————————————  note
                    CustomTextField(
                      controller: _noteController,
                      label: 'ملاحظة',
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: 2,
                      unfocusOnTapOutSide: true,
                    ),

                    const SizedBox(height: 24),

                    // ———————————————————————————————————————————————————————————  Submit Button
                    FilledButton.icon(
                      onPressed: () => _submitExpense(context),
                      icon: const Icon(Icons.check),
                      label: const Text('Save Expense'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              );
            }

            // ———————————————————————————————————————————————————————————  IN CASE OF AN ERROR
            return ErrorPage();
          },
        ),
      ),
    );
  }
}
