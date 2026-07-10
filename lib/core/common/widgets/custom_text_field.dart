import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final Widget? hint;
  final EdgeInsetsGeometry? contentPadding;
  final bool? alignLabelWithHint;
  final bool? isDense;
  final TextEditingController? controller;
  final bool isObscure;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    this.label,
    this.controller,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.hintText,
    this.hint,
    this.contentPadding,
    this.alignLabelWithHint,
    this.isDense,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      onChanged: onChanged,
      // Ensures the text typed inside follows RTL flow
      // textAlign: TextAlign.right,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hint: hint,
        isDense: isDense,
        contentPadding: contentPadding,
        // Align label to the right
        alignLabelWithHint: alignLabelWithHint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 1),
        ),
      ),
    );
  }
}
