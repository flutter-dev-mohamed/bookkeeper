import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/app_consts.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/widgets/shell_route_widget.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:shagaf_ledger/features/inventory/presentation/cubit/archived_products_cubit/archived_products_cubit.dart';
import 'package:shagaf_ledger/features/inventory/presentation/cubit/edit_product_cubit/edit_product_cubit.dart';
import 'package:shagaf_ledger/features/inventory/presentation/cubit/product_cubit/product_cubit.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/add_product_page.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/archived_products_page.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/inventory_page.dart';
import 'package:shagaf_ledger/features/inventory/presentation/widgets/edit_product_page.dart';
import 'package:shagaf_ledger/features/orders/presentation/add_order_cubit/add_order_cubit.dart';
import 'package:shagaf_ledger/features/orders/presentation/orders_bloc/orders_bloc.dart';
import 'package:shagaf_ledger/features/orders/presentation/order_details_cubit/order_details_cubit.dart';
import 'package:shagaf_ledger/features/orders/presentation/pages/add_order_page.dart';
import 'package:shagaf_ledger/features/orders/presentation/pages/order_details_page.dart';
import 'package:shagaf_ledger/features/orders/presentation/pages/orders_page.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/product_details_page.dart';
import 'package:shagaf_ledger/initDependencies/init_dependencies.dart';

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

          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => serviceLocator<InventoryBloc>(),
              ),
              BlocProvider(create: (context) => serviceLocator<OrdersBloc>()),
            ],
            child: ShellRouteWidget(index: index, child: child),
          );
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
        builder: (context, state) {
          return BlocProvider(
            create: (context) => serviceLocator<ArchivedProductsCubit>(),
            child: ArchivedProductsPage(),
          );
        },
      ),

      // add product page
      GoRoute(
        path: "/inventory/add_product",
        name: AppConsts().addProductPage,
        builder: (context, state) => AddProductPage(),
      ),

      // - product details page
      GoRoute(
        path: "/:productId",
        name: AppConsts().productDetailsPage,
        builder: (context, state) {
          final productId = int.parse(state.pathParameters['productId']!);

          return BlocProvider(
            create: (context) => serviceLocator<ProductCubit>(),
            child: ProductDetailsPage(productId: productId),
          );
        },
        routes: [
          GoRoute(
            path: "edit_product",
            name: AppConsts().editProductPage,
            builder: (context, state) {
              final product = state.extra! as Product;

              return BlocProvider(
                create: (context) => serviceLocator<EditProductCubit>(),
                child: EditProductPage(product: product),
              );
            },
          ),
        ],
      ),

      // add order
      GoRoute(
        path: "/orders/addNewOrder",
        name: AppConsts().addNewOrderPage,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => serviceLocator<AddOrderCubit>(),
            child: AddOrderPage(),
          );
        },
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
          return BlocProvider(
            create: (context) => serviceLocator<OrderDetailsCubit>(),
            child: OrderDetailsPage(orderId: orderId),
          );
        },
      ),
    ],
  );
}
