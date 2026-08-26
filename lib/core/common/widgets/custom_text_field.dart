import 'package:flutter/material.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final Widget? hint;
  final EdgeInsetsGeometry? contentPadding;
  final bool? alignLabelWithHint;
  final bool? isDense;
  final TextEditingController? controller;
  final bool isObscure;
  final bool enabled;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final bool unfocusOnTapOutSide;
  final void Function(PointerDownEvent)? onTapOutside;
  final String? suffixText;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;

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
    this.enabled = true,
    this.suffix,
    this.textInputAction,
    this.maxLines,
    this.minLines,
    this.onTapOutside,
    this.unfocusOnTapOutSide = false,
    this.suffixText,
    this.onSubmitted,
    this.onTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      obscureText: widget.isObscure,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      enabled: widget.enabled,
      onTapOutside:
          widget.onTapOutside ??
          (event) {
            if (widget.unfocusOnTapOutSide) {
              _focusNode.unfocus();
            }
          },
      // Ensures the text typed inside follows RTL flow
      // textAlign: TextAlign.right,
      decoration: InputDecoration(
        suffixText: widget.suffixText,
        labelText: widget.label,
        hintText: widget.hintText,
        hint: widget.hint,
        isDense: widget.isDense,
        contentPadding: widget.contentPadding,
        // Align label to the right
        alignLabelWithHint: widget.alignLabelWithHint,
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
        suffix: widget.suffix,
      ),
    );
  }
}
