import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final double? leadingWidth;
  final Widget? title;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    this.leading,
    this.actions,
    this.title,
    this.leadingWidth,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      // borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20.0)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: AppBar(
          backgroundColor: colorScheme.primary.withAlpha(30),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: colorScheme.primary.withAlpha(50)),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
          ),
          elevation: 0,

          title: title,
          centerTitle: true,

          leading: (leading != null)
              ? Row(mainAxisSize: MainAxisSize.min, children: [leading!])
              : null,
          leadingWidth: leadingWidth,

          actions: actions,
        ),
      ),
    );
  }
}
