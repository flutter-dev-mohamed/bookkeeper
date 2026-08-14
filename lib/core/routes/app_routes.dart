import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/app_consts.dart';
import 'package:shagaf_ledger/core/common/widgets/shell_route_widget.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/add_product_page.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/inventory_page.dart';
import 'package:shagaf_ledger/features/orders/presentation/pages/add_order_page.dart';
import 'package:shagaf_ledger/features/orders/presentation/pages/orders_page.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/product_details_page.dart';

class AppRoutes {
  static final AppRoutes _instance = AppRoutes._internal();

  factory AppRoutes() => _instance;

  AppRoutes._internal();

  GoRouter goRouter = GoRouter(
    initialLocation: "/orders",
    routes: [
      // you should have:
      // in a shell route
      ShellRoute(
        builder: (context, state, child) {
          final int index = state.matchedLocation == '/orders' ? 1 : 0;
          return ShellRouteWidget(index: index);
        },
        routes: [
          // orders page
          GoRoute(
            //
            path: "/orders",
            name: AppConsts().ordersPage,
            builder: (context, state) => OrdersPage(),
            routes: [
              // - the order page
            ],
          ),

          // inventory page
          GoRoute(
            path: "/inventory",
            name: AppConsts().inventoryPage,
            builder: (context, state) => InventoryPage(),
          ),
        ],
      ),
      // add product page
      GoRoute(
        path: "/inventory/add_product",
        name: AppConsts().addProductPage,
        builder: (context, state) => AddProductPage(),
      ),

      // - product details page
      GoRoute(
        path: "/inventory/:productId",
        name: AppConsts().productDetailsPage,
        builder: (context, state) {
          final id = state.pathParameters['productId'];
          return ProductDetailsPage(productId: int.parse(id ?? ''));
        },
      ),

      // add order
      GoRoute(
        path: "/orders/addNewOrder",
        name: AppConsts().addNewOrderPage,
        builder: (context, state) => AddOrderPage(),
      ),
    ],
  );
}
