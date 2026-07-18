import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/inventory_page.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/orders_page.dart';

class ShellRouteWidget extends StatefulWidget {
  final int index;

  const ShellRouteWidget({super.key, required this.index});

  @override
  State<ShellRouteWidget> createState() => _ShellRouteWidgetState();
}

class _ShellRouteWidgetState extends State<ShellRouteWidget> {
  final List<Widget> _pages = [const InventoryPage(), const OrdersPage()];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // IndexedStack maintains the state of all pages in the list
        body: IndexedStack(index: widget.index, children: _pages),
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
            if (index == 1) context.go('/orders');
            if (index == 0) context.go('/inventory');
          },
        ),
      ),
    );
  }
}
