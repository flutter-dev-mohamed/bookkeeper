import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/app_consts.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/core/routes/home.dart';
import 'package:shagaf_ledger/features/clients/domain/entities/client_entity.dart';
import 'package:shagaf_ledger/features/clients/presentation/pages/add_client_page.dart';
import 'package:shagaf_ledger/features/clients/presentation/pages/clients_details_page.dart';
import 'package:shagaf_ledger/features/clients/presentation/pages/clients_page.dart';
import 'package:shagaf_ledger/features/clients/presentation/state_management/add_client_cubit/add_client_cubit.dart';
import 'package:shagaf_ledger/features/clients/presentation/state_management/client_details_cubit/client_details_cubit.dart';
import 'package:shagaf_ledger/features/clients/presentation/state_management/clients_cubit/clients_cubit.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/inventory_addition.dart';
import 'package:shagaf_ledger/features/inventory/domain/repository/inventory_history_repository.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/add_inventory_addition.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/inventory_addition_details_page.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/inventory_history_page.dart';
import 'package:shagaf_ledger/features/inventory/presentation/state/add_inventory_addition_cubit/add_inventory_addition_cubit.dart';
import 'package:shagaf_ledger/features/inventory/presentation/state/inventory_history_cubit/inventory_history_cubit.dart';
import 'package:shagaf_ledger/features/orders/presentation/client_orders_cubit/client_orders_cubit.dart';
import 'package:shagaf_ledger/features/products/presentation/bloc/products_bloc.dart';
import 'package:shagaf_ledger/features/products/presentation/cubit/archived_products_cubit/archived_products_cubit.dart';
import 'package:shagaf_ledger/features/products/presentation/cubit/edit_product_cubit/edit_product_cubit.dart';
import 'package:shagaf_ledger/features/products/presentation/cubit/product_cubit/product_cubit.dart';
import 'package:shagaf_ledger/features/products/presentation/pages/add_product_page.dart';
import 'package:shagaf_ledger/features/products/presentation/pages/archived_products_page.dart';
import 'package:shagaf_ledger/features/products/presentation/pages/products_page.dart';
import 'package:shagaf_ledger/features/products/presentation/widgets/edit_product_page.dart';
import 'package:shagaf_ledger/features/orders/presentation/add_order_cubit/add_order_cubit.dart';
import 'package:shagaf_ledger/features/orders/presentation/orders_bloc/orders_bloc.dart';
import 'package:shagaf_ledger/features/orders/presentation/order_details_cubit/order_details_cubit.dart';
import 'package:shagaf_ledger/features/orders/presentation/pages/add_order_page.dart';
import 'package:shagaf_ledger/features/orders/presentation/pages/order_details_page.dart';
import 'package:shagaf_ledger/features/orders/presentation/pages/orders_page.dart';
import 'package:shagaf_ledger/features/products/presentation/pages/product_details_page.dart';
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
          final int index = state.matchedLocation.startsWith('/orders')
              ? 1
              : state.matchedLocation.startsWith('/products')
              ? 0
              : 2;

          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => serviceLocator<ProductsBloc>()),
              BlocProvider(create: (context) => serviceLocator<OrdersBloc>()),
              BlocProvider(create: (context) => serviceLocator<ClientsCubit>()),
            ],
            child: Home(index: index),
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
            path: '/products',
            name: AppConsts().productsPage,
            builder: (context, state) => ProductsPage(),
          ),

          // clients page
          GoRoute(
            path: '/clients',
            name: AppConsts().clientsPage,
            builder: (context, state) => ClientsPage(),
          ),
        ],
      ),

      // clients page
      // client details page
      GoRoute(
        path: '/clients/:clientId',
        name: AppConsts().clientDetailsPage,
        builder: (context, state) {
          final clientId = int.parse(state.pathParameters['clientId'] ?? "");

          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    serviceLocator<ClientOrdersCubit>(param1: clientId),
              ),
              BlocProvider(
                create: (context) =>
                    serviceLocator<ClientDetailsCubit>(param1: clientId),
              ),
            ],

            child: ClientDetailsPage(clientId: clientId),
          );
        },
      ),

      // add client page
      GoRoute(
        path: '/add_client_page',
        name: AppConsts().addClientPage,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => serviceLocator<AddClientCubit>(),
            child: AddClientPage(),
          );
        },
      ),

      // archived products page
      GoRoute(
        path: '/products/archived_products',
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
        path: "/products/add_product",
        name: AppConsts().addProductPage,
        builder: (context, state) => BlocProvider(
          create: (context) => serviceLocator<ProductsBloc>(),
          child: AddProductPage(),
        ),
      ),

      // - product details page
      GoRoute(
        path: "/:productId",
        name: AppConsts().productDetailsPage,
        builder: (context, state) {
          final productId = int.parse(state.pathParameters['productId']!);

          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => serviceLocator<ProductCubit>()),
              BlocProvider(
                create: (context) => serviceLocator<InventoryHistoryCubit>(),
              ),
              BlocProvider(
                create: (context) =>
                    serviceLocator<AddInventoryAdditionCubit>(),
              ),
            ],
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
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => serviceLocator<AddOrderCubit>(),
              ),
              BlocProvider(create: (context) => serviceLocator<ClientsCubit>()),
            ],
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

      GoRoute(
        path: '/products/inventoryHistory',
        name: AppConsts().inventoryHistoryPage,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => serviceLocator<InventoryHistoryCubit>(),
            child: InventoryHistoryPage(),
          );
        },
        routes: [
          GoRoute(
            path: 'inventory_addition_details',
            name: AppConsts().inventoryAdditionDetailsPage,
            builder: (context, state) {
              final addition = state.extra as InventoryAddition;

              return InventoryAdditionDetailsPage(addition: addition);
            },
          ),
        ],
      ),
    ],
  );
}
