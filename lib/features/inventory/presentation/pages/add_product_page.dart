import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_text_field.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/presentation/bloc/inventory_bloc.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    _costController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _addProduct() {
    if (_nameController.text.trim().isEmpty ||
        _costController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty ||
        _stockController.text.trim().isEmpty) {
      OPrint.br('============================');
      return;
    }
    final newProduct = Product(
      id: 0,
      name: _nameController.text.trim(),
      note: _noteController.text.trim(),
      purchasePrice: double.tryParse(_costController.text.trim()) ?? 0.0,
      sellingPrice: double.tryParse(_priceController.text.trim()) ?? 0.0,
      currentInventory: int.tryParse(_stockController.text.trim()) ?? 0,
      createdAt: DateTime.now(),
    );

    context.read<InventoryBloc>().add(AddProductEvent(product: newProduct));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'إضافة منتج',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocConsumer<InventoryBloc, InventoryState>(
            listener: (context, state) {
              if (state is InventorySuccess) {
                context.pop();
              }
            },
            builder: (context, state) {
              final isLoading = state is InventoryLoading;

              return SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Product information
                            Text(
                              'معلومات المنتج',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 12),

                            CustomTextField(
                              label: 'اسم المنتج',
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                            ),

                            const SizedBox(height: 12),

                            CustomTextField(
                              label: 'ملاحظة',
                              controller: _noteController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                            ),

                            const SizedBox(height: 28),

                            // Pricing
                            Text(
                              'التسعير',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    label: 'سعر البيع',
                                    controller: _priceController,
                                    textInputAction: TextInputAction.next,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomTextField(
                                    label: 'تكلفة المنتج',
                                    controller: _costController,
                                    textInputAction: TextInputAction.next,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 28),

                            // Inventory
                            Text(
                              'المخزون',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 12),

                            CustomTextField(
                              label: 'المخزون الأولي',
                              controller: _stockController,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'عدد الوحدات الموجودة عند إضافة المنتج.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom action area
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        border: Border(
                          top: BorderSide(color: colorScheme.outlineVariant),
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: CustomPrimaryButton(
                          text: isLoading ? 'جاري الحفظ...' : 'حفظ المنتج',
                          onPressed: isLoading ? null : _addProduct,
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.check_rounded, size: 22),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
