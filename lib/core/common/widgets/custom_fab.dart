import 'dart:ui';

import 'package:flutter/material.dart';

class CustomFab extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;

  const CustomFab({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.primary.withAlpha(35),
            border: Border.all(
              color: colorScheme.primary.withAlpha(55),
              width: 0.7,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(28)),
          ),
          child: FloatingActionButton(
            heroTag: null,
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: colorScheme.onSecondaryContainer,
            shape: CircleBorder(),
            onPressed: onPressed,
            child: child,
          ),
        ),
      ),
    );
  }
}
