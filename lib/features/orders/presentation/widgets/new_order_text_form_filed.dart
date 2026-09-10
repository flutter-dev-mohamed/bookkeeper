import 'package:flutter/material.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';

class NewOrderTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;
  final String? prefixText;
  final bool enabled;
  final TextAlign textAlign;
  void Function(String)? onChanged;

  NewOrderTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.prefixText,
    this.enabled = true,
    this.textAlign = TextAlign.start,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      validator: validator,
      textAlign: textAlign,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        prefixText: prefixText,
        filled: readOnly,
      ),
    );
  }
}
