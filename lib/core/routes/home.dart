import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/icons/app_icons.dart';

class Home extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const Home({
    super.key = const ValueKey<String>("HomePage"),
    required this.navigationShell,
  });

  List<Widget> get destinations => [
    NavigationDestination(
      label: 'Clients',
      icon: Image.asset(AppIcons.usersAvatarOutlined, width: 30, height: 30),
      selectedIcon: Image.asset(
        AppIcons.usersAvatarFilled,
        width: 30,
        height: 30,
      ),
    ),
    NavigationDestination(
      label: 'Orders',
      icon: Image.asset(AppIcons.orderOutlined, width: 30, height: 30),
      selectedIcon: Image.asset(AppIcons.orderFilled, width: 30, height: 30),
    ),
    NavigationDestination(
      label: 'Products',
      icon: Image.asset(AppIcons.packageOutlined, width: 30, height: 30),
      selectedIcon: Image.asset(AppIcons.packageFilled, width: 30, height: 30),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: NEED A LISTENER FOR THE PRODUCTS PAGE TO UPDATE ON ADDING AN ORDER LIKE THIS:
    //    return BlocListener<OrdersBloc, OrdersState>(
    //       listener: (context, state) {
    //         if (state is OrdersUpdating) _reloadProducts(context);
    //       },

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // ———————————————————————————————————————————————————————————————————————  body
      body: navigationShell,

      // ———————————————————————————————————————————————————————————————————————  bottom nav
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(30),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                color: colorScheme.primary.withAlpha(50),
                width: 1.0,
              ),
            ),

            child: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: navigationShell.goBranch,
              destinations: destinations,

              height: 70,
              backgroundColor: Colors.transparent,
              // Must be transparent to let the blur show
              indicatorColor: Colors.white.withAlpha(40),
              // Sleek highlight for active item
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
            ),
          ),
        ),
      ),
    );
  }
}
