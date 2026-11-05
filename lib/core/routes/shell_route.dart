import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/routes/app_page_names.dart';
import 'package:shagaf_ledger/core/routes/app_routes.dart';
import 'package:shagaf_ledger/core/routes/home.dart';
import 'package:shagaf_ledger/features/clients/presentation/pages/add_client_page.dart';
import 'package:shagaf_ledger/features/clients/presentation/pages/clients_page.dart';
import 'package:shagaf_ledger/features/clients/presentation/state_management/add_client_cubit/add_client_cubit.dart';
import 'package:shagaf_ledger/features/clients/presentation/state_management/client_details_cubit/client_details_cubit.dart';
import 'package:shagaf_ledger/features/clients/presentation/state_management/clients_cubit/clients_cubit.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/inventory_addition.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/inventory_addition_details_page.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/inventory_history_page.dart';
import 'package:shagaf_ledger/features/inventory/presentation/state/add_inventory_addition_cubit/add_inventory_addition_cubit.dart';
import 'package:shagaf_ledger/features/inventory/presentation/state/inventory_history_cubit/inventory_history_cubit.dart';
import 'package:shagaf_ledger/features/orders/presentation/add_order_cubit/add_order_cubit.dart';
import 'package:shagaf_ledger/features/orders/presentation/client_orders_cubit/client_orders_cubit.dart';
import 'package:shagaf_ledger/features/orders/presentation/order_details_cubit/order_details_cubit.dart';
import 'package:shagaf_ledger/features/orders/presentation/orders_bloc/orders_bloc.dart';
import 'package:shagaf_ledger/features/orders/presentation/pages/add_order_page.dart';
import 'package:shagaf_ledger/features/orders/presentation/pages/order_details_page.dart';
import 'package:shagaf_ledger/features/orders/presentation/pages/orders_page.dart';
import 'package:shagaf_ledger/features/products/presentation/bloc/products_bloc.dart';
import 'package:shagaf_ledger/features/products/presentation/cubit/archived_products_cubit/archived_products_cubit.dart';
import 'package:shagaf_ledger/features/products/presentation/cubit/edit_product_cubit/edit_product_cubit.dart';
import 'package:shagaf_ledger/features/products/presentation/cubit/product_cubit/product_cubit.dart';
import 'package:shagaf_ledger/features/products/presentation/pages/add_product_page.dart';
import 'package:shagaf_ledger/features/products/presentation/pages/archived_products_page.dart';
import 'package:shagaf_ledger/features/products/presentation/pages/product_details_page.dart';
import 'package:shagaf_ledger/features/products/presentation/pages/products_page.dart';
import 'package:shagaf_ledger/features/products/presentation/widgets/edit_product_page.dart';
import 'package:shagaf_ledger/initDependencies/init_dependencies.dart';

part 'shell_parts/clients_branch.dart';

part 'shell_parts/orders_branch.dart';

part 'shell_parts/products_branch.dart';

final _routeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "root");

final router = GoRouter(
  navigatorKey: _routeNavigatorKey,
  initialLocation: AppRoutes.ordersPage,
  
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          Home(navigationShell: navigationShell),
      branches: [
        //
        clientsBranch,
        //
        ordersBranch,
        //
        productsBranch,
      ],
    ),
  ],
);
