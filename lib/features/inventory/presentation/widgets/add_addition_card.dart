import 'package:flutter/material.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_text_field.dart';

class AddAdditionCard extends StatefulWidget {
  final void Function(
    int stock,
    double unitPurchasePrice,
    double unitSellingPrice,
    String note,
  )
  onUpdateSate;

  const AddAdditionCard({super.key, required this.onUpdateSate});

  @override
  State<AddAdditionCard> createState() => _AddAdditionCardState();
}

class _AddAdditionCardState extends State<AddAdditionCard> {
  late final TextEditingController _stockController;
  late final TextEditingController _noteController;
  late final TextEditingController _costController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    _stockController = TextEditingController();
    _noteController = TextEditingController();
    _costController = TextEditingController();
    _priceController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _stockController.dispose();
    _noteController.dispose();
    _costController.dispose();
    _priceController.dispose();

    super.dispose();
  }

  void _onTextSubmit() => widget.onUpdateSate(
    int.parse(_stockController.text),
    double.parse(_costController.text),
    double.parse(_priceController.text),
    _noteController.text,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 300, maxWidth: 500, maxHeight: 350),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
              CustomTextField(
                label: 'المخزون الإضافي',
                controller: _stockController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                maxLines: 1,
                onSubmitted: (_) => _onTextSubmit(),
                onTapOutside: (_) => _onTextSubmit(),
                onTap: () => _stockController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _stockController.text.length,
                ),
              ),

              // —————————————————————————————————————————————————————————————————  prices
              Text(
                'التسعير',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'تكلفة المنتج',
                      controller: _costController,
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onSubmitted: (_) => _onTextSubmit(),
                      onTapOutside: (_) => _onTextSubmit(),
                      onTap: () => _costController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _costController.text.length,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: 'سعر البيع',
                      controller: _priceController,
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onSubmitted: (_) => _onTextSubmit(),
                      onTapOutside: (_) => _onTextSubmit(),
                      onTap: () => _priceController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _priceController.text.length,
                      ),
                    ),
                  ),
                ],
              ),

              // —————————————————————————————————————————————————————————————————  note
              CustomTextField(
                label: 'ملاحظة',
                controller: _noteController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                maxLines: 4,
                minLines: 1,
                onSubmitted: (_) => _onTextSubmit(),
                onTapOutside: (_) => _onTextSubmit(),
                onTap: () => _noteController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _noteController.text.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
