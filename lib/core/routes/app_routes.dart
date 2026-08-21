import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/app_consts.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/widgets/shell_route_widget.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/add_product_page.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/archived_products_page.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/inventory_page.dart';
import 'package:shagaf_ledger/features/inventory/presentation/widgets/edit_product_page.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/get_order_details.dart';
import 'package:shagaf_ledger/features/orders/presentation/order_details_cubit/order_details_cubit.dart';
import 'package:shagaf_ledger/features/orders/presentation/pages/add_order_page.dart';
import 'package:shagaf_ledger/features/orders/presentation/pages/order_details_page.dart';
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
          final int index = state.matchedLocation.startsWith('/orders') ? 1 : 0;

          return ShellRouteWidget(index: index, child: child);
        },
        routes: [
          // orders page
          GoRoute(
            path: '/orders',
            name: AppConsts().ordersPage,
            builder: (context, state) => OrdersPage(),
          ),

          // inventory page
          GoRoute(
            path: '/inventory',
            name: AppConsts().inventoryPage,
            builder: (context, state) => InventoryPage(),
          ),
        ],
      ),

      GoRoute(
        path: '/inventory/archived_products',
        name: AppConsts().archivedProductsPage,
        builder: (context, state) => ArchivedProductsPage(),
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
          final id = state.pathParameters['productId']!;
          return ProductDetailsPage(productId: int.parse(id));
        },
        routes: [
          GoRoute(
            path: "edit_product",
            name: AppConsts().editProductPage,
            builder: (context, state) {
              final id = state.pathParameters['productId']!;
              return EditProductPage(productId: int.parse(id));
            },
          ),
        ],
      ),

      // add order
      GoRoute(
        path: "/orders/addNewOrder",
        name: AppConsts().addNewOrderPage,
        builder: (context, state) => AddOrderPage(),
      ),

      // order details page
      GoRoute(
        path: "/orders/:orderId",
        name: AppConsts().orderDetails,
        builder: (context, state) {
          final orderId = int.tryParse(state.pathParameters['orderId'] ?? '');
          if (orderId == null) {
            return ErrorPage();
          }
          return OrderDetailsPage(orderId: orderId);
        },
      ),
    ],
  );
}
