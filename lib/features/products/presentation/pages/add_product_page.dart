import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_app_bar.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_form_filed.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/products/presentation/bloc/products_bloc.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _noteController;
  late final TextEditingController _costController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _addedCostController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _noteController = TextEditingController();
    _costController = TextEditingController();
    _priceController = TextEditingController();
    _stockController = TextEditingController();
    _addedCostController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    _costController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _addedCostController.dispose();
    super.dispose();
  }

  void _addProduct() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
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

    final addedCost = double.tryParse(_addedCostController.text) ?? 0;
    context.read<ProductsBloc>().add(
      AddProductEvent(product: newProduct, addedCost: addedCost),
    );
  }

  String? _validateStock(String? value) {
    if (value == null || value.trim().isEmpty) return 'يرجى إدخال كمية المخزون';

    final stock = int.tryParse(value);
    if (stock == null) return 'يرجى إدخال رقم صحيح';
    if (stock <= 0) return 'يجب أن تكون الكمية أكبر من صفر';
    return null;
  }

  String? _validatePrice(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return 'يرجى إدخال $fieldName';

    final price = double.tryParse(value);
    if (price == null) return 'يرجى إدخال رقم صحيح';
    if (price <= 0) return 'يجب أن يكون السعر أكبر من صفر';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(
          title: const Text(
            'إضافة منتج',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocConsumer<ProductsBloc, ProductsState>(
            listener: (context, state) {
              if (state is InventorySuccess) {
                context.pop();
              }
            },
            builder: (context, state) {
              final isLoading = state is InventoryLoading;

              return SafeArea(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteractionIfError,
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

                              CustomFormField(
                                label: 'اسم المنتج',
                                controller: _nameController,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  final name = value?.trim() ?? '';
                                  if (name.isEmpty) {
                                    return 'يرجئ إدخال إسم المنتج';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 12),

                              CustomFormField(
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
                                    child: CustomFormField(
                                      label: 'تكلفة المنتج',
                                      controller: _costController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      validator: (price) =>
                                          _validatePrice(price, 'تكلفة المنتج'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomFormField(
                                      label: 'سعر البيع',
                                      controller: _priceController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      validator: (price) =>
                                          _validatePrice(price, 'سعر البيع'),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 28),

                              CustomFormField(
                                controller: _addedCostController,
                                label: 'تكلفة إضافية',
                                textInputAction: TextInputAction.next,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                validator: (value) =>
                                    _validatePrice(value, 'سعر البيع'),
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

                              CustomFormField(
                                label: 'المخزون الأولي',
                                controller: _stockController,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                validator: (stock) => _validateStock(stock),
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
