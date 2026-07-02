import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/app_consts.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/add_product_page.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/inventory_page.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/product_details_page.dart';

class AppRoutes {
  static final AppRoutes _instance = AppRoutes._internal();

  factory AppRoutes() => _instance;

  AppRoutes._internal();

  GoRouter goRouter = GoRouter(
    initialLocation: "/inventory",
    routes: [
      // you should have:
      // in a shell route
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: child,
            // Example: Add your bottom navigation bar here
            bottomNavigationBar: NavigationBar(
              destinations: const [
                NavigationDestination(icon: Icon(Icons.list), label: 'Orders'),
                NavigationDestination(
                  icon: Icon(Icons.inventory),
                  label: 'Inventory',
                ),
              ],
              onDestinationSelected: (index) {
                if (index == 0) context.go('/orders');
                if (index == 1) context.go('/inventory');
              },
            ),
          );
        },
        routes: [
          // orders page
          GoRoute(
            //
            path: "/orders",
            name: AppConsts().ordersPage,
            builder: (context, state) =>
                Scaffold(body: Center(child: Text('fuck'))),
            routes: [
              // - the order page
            ],
          ),

          // inventory page
          GoRoute(
            path: "/inventory",
            name: AppConsts().inventoryPage,
            builder: (context, state) => InventoryPage(),
            routes: [
              // add product page
              GoRoute(
                path: "add_product",
                name: AppConsts().addProductPage,
                builder: (context, state) => AddProductPage(),
              ),

              // - product details page
              GoRoute(
                path: ":productId",
                name: AppConsts().productDetailsPage,
                builder: (context, state) {
                  final id = state.pathParameters['productId'];
                  return ProductDetailsPage(productId: int.parse(id ?? ''));
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
