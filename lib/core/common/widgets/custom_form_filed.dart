import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final void Function(PointerDownEvent)? onTapOutside;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final Widget? prefix;
  final Widget? icon;
  final FocusNode? focusNode;

  const CustomFormField({
    super.key,
    required this.controller,
    this.label,
    this.validator,
    this.onFieldSubmitted,
    this.onTapOutside,
    this.textInputAction,
    this.keyboardType,
    this.suffix,
    this.prefix,
    this.icon,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        suffix: suffix,
        prefix: prefix,
        icon: icon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
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
      textInputAction: textInputAction,
      maxLines: 1,
      keyboardType: keyboardType,
      validator: validator,
      onFieldSubmitted: (_) => onFieldSubmitted,
      onTapOutside: (_) => onTapOutside,
      onTap: () {
        controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controller.text.length,
        );
      },
    );
  }
}
