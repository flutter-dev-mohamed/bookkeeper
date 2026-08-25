import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellRouteWidget extends StatefulWidget {
  final int index;
  final Widget child;

  const ShellRouteWidget({super.key, required this.index, required this.child});

  @override
  State<ShellRouteWidget> createState() => _ShellRouteWidgetState();
}

class _ShellRouteWidgetState extends State<ShellRouteWidget> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: widget.child,

        bottomNavigationBar: NavigationBar(
          selectedIndex: widget.index,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.inventory),
              label: 'Inventory',
            ),
            NavigationDestination(icon: Icon(Icons.list), label: 'Orders'),
          ],
          onDestinationSelected: (index) {
            if (index == 1) {
              context.go('/orders');
            }

            if (index == 0) {
              context.go('/products');
            }
          },
        ),
      ),
    );
  }
}
