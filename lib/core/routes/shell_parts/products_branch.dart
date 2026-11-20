part of '../shell_route.dart';

final productsBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      path: AppRoutes.productsPage,
      builder: (context, state) => BlocProvider(
        create: (context) => serviceLocator<ProductsBloc>(),
        child: ProductsPage(),
      ),
      routes: [
        // —————————————————————————————————————————————————————————————————————  add product page
        GoRoute(
          path: AppRoutes.addProduct,
          name: AppPageNames.addProductPage,
          parentNavigatorKey: _routeNavigatorKey,
          builder: (context, state) => BlocProvider(
            create: (context) => serviceLocator<ProductsBloc>(),
            child: AddProductPage(),
          ),
        ),
        // —————————————————————————————————————————————————————————————————————  product details page
        GoRoute(
          path: AppRoutes.productDetails,
          name: AppPageNames.productDetailsPage,
          parentNavigatorKey: _routeNavigatorKey,
          builder: (context, state) {
            final productId = int.parse(state.pathParameters['productId']!);
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => serviceLocator<ProductCubit>(),
                ),
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
            // —————————————————————————————————————————————————————————————————  edit product page
            GoRoute(
              path: AppRoutes.editProduct,
              name: AppPageNames.editProductPage,
              builder: (context, state) {
                // TODO: FIX THIS SHOULD NOT USE "!"
                final product = state.extra! as Product;

                return BlocProvider(
                  create: (context) => serviceLocator<EditProductCubit>(),
                  child: EditProductPage(product: product),
                );
              },
            ),
          ],
        ),

        // ————————————————————————————————————————————————————————————————————— archived products page
        GoRoute(
          path: AppRoutes.archivedProducts,
          name: AppPageNames.archivedProductsPage,
          parentNavigatorKey: _routeNavigatorKey,
          builder: (context, state) {
            return BlocProvider(
              create: (context) => serviceLocator<ArchivedProductsCubit>(),
              child: ArchivedProductsPage(),
            );
          },
          routes: [
            // TODO: SHOULD ADD AN ARCHIVED PRODUCT DETAILS PAGE ROUTE!
          ],
        ),

        // —————————————————————————————————————————————————————————————————————  inventory history
        GoRoute(
          path: AppRoutes.inventoryHistory,
          name: AppPageNames.inventoryHistoryPage,
          parentNavigatorKey: _routeNavigatorKey,
          builder: (context, state) => BlocProvider(
            create: (context) => serviceLocator<InventoryHistoryCubit>(),
            child: InventoryHistoryPage(),
          ),
          routes: [
            // —————————————————————————————————————————————————————————————————  inventory addition details
            GoRoute(
              path: AppRoutes.inventoryAdditionDetails,
              name: AppPageNames.inventoryAdditionDetailsPage,
              builder: (context, state) {
                final addition = state.extra as InventoryAddition;

                return InventoryAdditionDetailsPage(addition: addition);
              },
            ),
          ],
        ),

        // details // edit
      ],
    ),
  ],
);
