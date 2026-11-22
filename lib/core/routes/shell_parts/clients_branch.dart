part of '../shell_route.dart';

final clientsBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      path: AppRoutes.clientsPage,
      name: AppPageNames.clientsPage,
      builder: (context, state) => BlocProvider(
        create: (context) => serviceLocator<ClientsCubit>(),
        child: ClientsPage(),
      ),
      routes: [
        // —————————————————————————————————————————————————————————————————————  add client page
        GoRoute(
          path: AppRoutes.addClient,
          name: AppPageNames.addClientPage,
          parentNavigatorKey: _routeNavigatorKey,
          builder: (context, state) => BlocProvider(
            create: (context) => serviceLocator<AddClientCubit>(),
            child: AddClientPage(),
          ),
        ),

        // —————————————————————————————————————————————————————————————————————  client details page
        GoRoute(
          path: AppRoutes.clientDetails,
          name: AppPageNames.clientDetailsPage,
          parentNavigatorKey: _routeNavigatorKey,
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
      ],
    ),
  ],
);
