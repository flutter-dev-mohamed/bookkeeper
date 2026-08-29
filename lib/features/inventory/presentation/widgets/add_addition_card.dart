import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_form_filed.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/inventory_addition.dart';
import 'package:shagaf_ledger/features/inventory/presentation/state/add_inventory_addition_cubit/add_inventory_addition_cubit.dart';

class AddAdditionCard extends StatefulWidget {
  final int productId;
  final String productName;
  final GlobalKey<FormState> formKey;

  const AddAdditionCard({
    super.key,
    required this.productId,
    required this.formKey,
    required this.productName,
  });

  @override
  State<AddAdditionCard> createState() => _AddAdditionCardState();
}

class _AddAdditionCardState extends State<AddAdditionCard> {
  late final TextEditingController _quantityController;
  late final TextEditingController _noteController;
  late final TextEditingController _costController;
  late final TextEditingController _priceController;
  late final TextEditingController _addedCostController;

  @override
  void initState() {
    _quantityController = TextEditingController();
    _noteController = TextEditingController();
    _costController = TextEditingController();
    _priceController = TextEditingController();
    _addedCostController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _noteController.dispose();
    _costController.dispose();
    _priceController.dispose();
    _addedCostController.dispose();

    super.dispose();
  }

  void _onTextSubmit(BuildContext context) {
    context.read<AddInventoryAdditionCubit>().updateState(
      inventoryAddition: InventoryAddition(
        id: 0,
        productId: widget.productId,
        productName: widget.productName,
        quantity: int.tryParse(_quantityController.text) ?? 0,
        unitPurchasePrice: double.tryParse(_costController.text) ?? 0,
        unitSellingPrice: double.tryParse(_priceController.text) ?? 0,
        addedCost: double.tryParse(_addedCostController.text) ?? 0,
        note: _noteController.text,
        createdAt: DateTime.now().toIso8601String().split('T')[0],
      ),
    );
  }

  String? _validateStock(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال كمية المخزون';
    }

    final stock = int.tryParse(value);

    if (stock == null) {
      return 'يرجى إدخال رقم صحيح';
    }

    if (stock <= 0) {
      return 'يجب أن تكون الكمية أكبر من صفر';
    }

    return null;
  }

  String? _validatePrice(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال $fieldName';
    }

    final price = double.tryParse(value);

    if (price == null) {
      return 'يرجى إدخال رقم صحيح';
    }

    if (price <= 0) {
      return 'يجب أن يكون السعر أكبر من صفر';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 300,
        maxWidth: 500,
        maxHeight: 350,
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                Text(
                  'المخزون',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                _formField(
                  controller: _quantityController,
                  label: 'المخزون الإضافي',
                  validator: _validateStock,
                ),

                // ————————————————————— prices
                Text(
                  'التسعير',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: _formField(
                        controller: _costController,
                        label: 'تكلفة المنتج',
                        validator: (value) =>
                            _validatePrice(value, 'تكلفة المنتج'),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _formField(
                        controller: _priceController,
                        label: 'سعر البيع',
                        validator: (value) =>
                            _validatePrice(value, 'سعر البيع'),
                      ),
                    ),
                  ],
                ),

                // ————————————————————————————————————————————————————————————— added cost
                _formField(
                  controller: _addedCostController,
                  label: 'تكلفة إضافية',
                  validator: (value) => _validatePrice(value, 'سعر البيع'),
                ),

                // ————————————————————————————————————————————————————————————— note
                TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    labelText: 'ملاحظة',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        width: 1,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
                  maxLines: 4,
                  minLines: 1,
                  onFieldSubmitted: (_) => _onTextSubmit(context),
                  onTapOutside: (_) => _onTextSubmit(context),
                  onTap: () {
                    _noteController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _noteController.text.length,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return CustomFormField(
      controller: controller,
      label: label,
      validator: validator,
      textInputAction: TextInputAction.next,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onTapOutside: (_) => _onTextSubmit(context),
      onFieldSubmitted: (_) {
        OPrint.lineY('onFieldSubmitted');
        _onTextSubmit(context);
      },
    );
  }
}
