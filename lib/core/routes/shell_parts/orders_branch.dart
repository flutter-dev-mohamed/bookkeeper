part of '../shell_route.dart';

final ordersBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      path: AppRoutes.ordersPage,
      builder: (context, state) => BlocProvider(
        create: (context) => serviceLocator<OrdersBloc>(),
        child: OrdersPage(),
      ),
      routes: [
        // —————————————————————————————————————————————————————————————————————  add order
        GoRoute(
          path: AppRoutes.addNewOrder,
          name: AppPageNames.addNewOrderPage,
          parentNavigatorKey: _routeNavigatorKey,
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => serviceLocator<AddOrderCubit>(),
                ),
                BlocProvider(
                  create: (context) => serviceLocator<ClientsCubit>(),
                ),
              ],
              child: AddOrderPage(),
            );
          },
        ),

        // —————————————————————————————————————————————————————————————————————  order details page
        GoRoute(
          path: AppRoutes.orderDetails,
          name: AppPageNames.orderDetails,
          parentNavigatorKey: _routeNavigatorKey,
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
    ),
  ],
);
