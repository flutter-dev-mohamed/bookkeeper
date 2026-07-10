import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_text_field.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/product.dart';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'أضف منتج',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //
              CustomTextField(label: 'اسم المنتج', controller: _nameController),
              CustomTextField(
                label: 'تكلفة المنتج',
                controller: _costController,
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                label: 'سعر المنتج',
                controller: _priceController,
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                label: 'المخزون الأولي',
                controller: _stockController,
                keyboardType: TextInputType.number,
              ),
              CustomTextField(label: 'ملاحظة', controller: _noteController),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //
                  Expanded(
                    child: BlocConsumer<InventoryBloc, InventoryState>(
                      listener: (context, state) {
                        if (state is InventoryProductAdded) {
                          context.pop();
                        }
                      },
                      builder: (context, state) {
                        return state is InventoryLoading
                            // TODO: make the loading a widget _loadingButton and disable it!
                            ? CustomPrimaryButton(
                                text: "Loading",
                                onPressed: () {},
                                child: CircularProgressIndicator(),
                              )
                            : CustomPrimaryButton(
                                text: 'حفظ المنتج',
                                onPressed: () {
                                  final newProduct = Product(
                                    id: 0,
                                    // Assuming 0 for a new product, or auto-incremented by DB
                                    name: _nameController.text.trim(),
                                    note: _noteController.text.trim(),
                                    purchasePrice:
                                        double.tryParse(
                                          _costController.text.trim(),
                                        ) ??
                                        0.0,
                                    sellingPrice:
                                        double.tryParse(
                                          _priceController.text.trim(),
                                        ) ??
                                        0.0,
                                    currentInventory:
                                        int.tryParse(
                                          _stockController.text.trim(),
                                        ) ??
                                        0,
                                    createdAt: DateTime.now(),
                                  );
                                  context.read<InventoryBloc>().add(
                                    AddProductEvent(product: newProduct),
                                  );
                                  OPrint.c(
                                    "Product should be add to db please!.",
                                  );
                                },
                              );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///   ElevatedButton(
//                     onPressed: () => OPrint.c("Add product to db please!."),
//                     style: ButtonStyle(
//                       shape: WidgetStatePropertyAll(
//                         ContinuousRectangleBorder(
//                           borderRadius: BorderRadiusGeometry.circular(12),
//                         ),
//                       ),
//                     ),
//                     child: Text(
//                       'إضاقة المنتج',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   )
