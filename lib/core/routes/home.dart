import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/features/clients/presentation/pages/clients_page.dart';
import 'package:shagaf_ledger/features/orders/presentation/orders_bloc/orders_bloc.dart';
import 'package:shagaf_ledger/features/orders/presentation/pages/orders_page.dart';
import 'package:shagaf_ledger/features/products/presentation/bloc/products_bloc.dart';
import 'package:shagaf_ledger/features/products/presentation/pages/products_page.dart';

class Home extends StatefulWidget {
  final int index;

  const Home({super.key, required this.index});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> pages = [ProductsPage(), OrdersPage(), ClientsPage()];

  void _reloadProducts(BuildContext context) =>
      context.read<ProductsBloc>().add(LoadProductsEvent());

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final index = widget.index;
    final clientsIcon = Image.asset(
      index == 2
          ? 'lib/core/assets/icons/users_avatar_filled.png'
          : 'lib/core/assets/icons/users_avatar_out_lined.png',
      color: colorScheme.primary,
      width: 30,
    );
    final ordersIcon = Image.asset(
      index == 1
          ? 'lib/core/assets/icons/order_filled.png'
          : 'lib/core/assets/icons/order_out_lined.png',
      color: colorScheme.primary,
      width: 30,
    );
    final productsIcon = Image.asset(
      index == 0
          ? 'lib/core/assets/icons/package_filled.png'
          : 'lib/core/assets/icons/package_out_lined.png',
      color: colorScheme.primary,
      width: 30,
    );

    return BlocListener<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state is OrdersUpdating) _reloadProducts(context);
      },

      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: IndexedStack(index: widget.index, children: pages),

          //
          bottomNavigationBar: NavigationBar(
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            selectedIndex: widget.index,
            destinations: [
              NavigationDestination(
                //
                icon: productsIcon,
                label: 'Products',
              ),
              NavigationDestination(
                //
                icon: ordersIcon,
                label: 'Orders',
              ),
              NavigationDestination(
                //
                icon: clientsIcon,
                label: 'Clients',
              ),
            ],
            onDestinationSelected: (index) {
              if (index == 2) {
                context.go('/clients');
              }

              if (index == 1) {
                context.go('/orders');
              }

              if (index == 0) {
                context.go('/products');
              }
            },
          ),
        ),
      ),
    );
  }
}
