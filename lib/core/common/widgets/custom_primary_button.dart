import 'package:flutter/material.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';

class CustomPrimaryButton extends StatelessWidget {
  final Widget? child;
  final String text;
  final void Function()? onPressed;

  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Get colors from your theme
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        // Set Primary color and On-Primary text color
        backgroundColor: backgroundColor ?? colorScheme.primary,
        foregroundColor: foregroundColor ?? colorScheme.onPrimary,

        // Define the rounded rectangle shape
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        // Add padding to make it look substantial like a login button
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),

        // Ensure elevation for the "lifted" look
        elevation: 4,
      ),
      child:
          child ??
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
    );
  }
}
