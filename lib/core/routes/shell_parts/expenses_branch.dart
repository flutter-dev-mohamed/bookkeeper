part of '../shell_route.dart';

final expensesBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      path: AppRoutes.expensesSummaryPage,
      name: AppPageNames.expensesSummaryPage,
      builder: (context, state) => BlocProvider(
        create: (context) => serviceLocator<ExpensesCubit>(),
        child: ExpensesSummaryPage(),
      ),
      routes: [
        // the sheet should be here
        GoRoute(
          path: AppRoutes.addExpense,
          name: AppPageNames.addExpensePage,
          parentNavigatorKey: _routeNavigatorKey,
          // Renders above Home's bottom nav bar
          pageBuilder: (context, state) => ModalBottomSheetPage(
            key: state.pageKey,
            child: BlocProvider(
              create: (context) => serviceLocator<AddExpenseCubit>(),
              child: const AddExpenseSheet(),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.expenses,
          name: AppPageNames.expensesPage,
          parentNavigatorKey: _routeNavigatorKey,
          builder: (context, state) => ExpensesPage(),
          //
        ),
      ],
    ),
  ],
);
