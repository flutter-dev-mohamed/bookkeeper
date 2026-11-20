import 'package:get_it/get_it.dart';
import 'package:shagaf_ledger/core/app_notifications/app_notifications.dart';
import 'package:shagaf_ledger/features/clients/data/database/clients_database.dart';
import 'package:shagaf_ledger/features/clients/data/repository/clients_repository_imp.dart';
import 'package:shagaf_ledger/features/clients/domain/repository/clients_repository.dart';
import 'package:shagaf_ledger/features/clients/domain/use_cases/add_client.dart';
import 'package:shagaf_ledger/features/clients/domain/use_cases/get_client_details.dart';
import 'package:shagaf_ledger/features/clients/domain/use_cases/get_clients.dart';
import 'package:shagaf_ledger/features/clients/presentation/state_management/add_client_cubit/add_client_cubit.dart';
import 'package:shagaf_ledger/features/clients/presentation/state_management/client_details_cubit/client_details_cubit.dart';
import 'package:shagaf_ledger/features/clients/presentation/state_management/clients_cubit/clients_cubit.dart';
import 'package:shagaf_ledger/features/daily_expenses/data/database/expenses_database.dart';
import 'package:shagaf_ledger/features/daily_expenses/data/repository/expenses_repo_imp.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/repository/expenses_repo.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/use_cases/add_expense.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/use_cases/get_all_expense.dart';
import 'package:shagaf_ledger/features/daily_expenses/presentation/state_management/add_expense/add_expense_cubit.dart';
import 'package:shagaf_ledger/features/daily_expenses/presentation/state_management/expenses/expenses_cubit.dart';
import 'package:shagaf_ledger/features/inventory/data/database/inventory_history_database.dart';
import 'package:shagaf_ledger/features/inventory/data/repository/inventory_history_repository_imp.dart';
import 'package:shagaf_ledger/features/inventory/domain/repository/inventory_history_repository.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/add_inventory_addition.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/get_inventory_additions.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/get_product_additions.dart';
import 'package:shagaf_ledger/features/inventory/presentation/state/add_inventory_addition_cubit/add_inventory_addition_cubit.dart';
import 'package:shagaf_ledger/features/inventory/presentation/state/inventory_history_cubit/inventory_history_cubit.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/get_client_orders.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/get_new_order.dart';
import 'package:shagaf_ledger/features/orders/presentation/client_orders_cubit/client_orders_cubit.dart';
import 'package:shagaf_ledger/features/orders/presentation/orders_cubit/orders_cubit.dart';
import 'package:shagaf_ledger/features/products/data/database/product_local_database.dart';
import 'package:shagaf_ledger/features/products/data/repository/products_repository_imp.dart';
import 'package:shagaf_ledger/features/products/domain/repository/products_repository.dart';
import 'package:shagaf_ledger/features/products/domain/use_cases/add_product.dart';
import 'package:shagaf_ledger/features/products/domain/use_cases/archive_product.dart';
import 'package:shagaf_ledger/features/products/domain/use_cases/get_archived_products.dart';
import 'package:shagaf_ledger/features/products/domain/use_cases/get_product_by_id.dart';
import 'package:shagaf_ledger/features/products/domain/use_cases/get_active_products.dart';
import 'package:shagaf_ledger/features/products/domain/use_cases/remove_product_from_archive.dart';
import 'package:shagaf_ledger/features/products/domain/use_cases/update_product.dart';
import 'package:shagaf_ledger/features/products/presentation/bloc/products_bloc.dart';
import 'package:shagaf_ledger/features/products/presentation/cubit/archived_products_cubit/archived_products_cubit.dart';
import 'package:shagaf_ledger/features/products/presentation/cubit/edit_product_cubit/edit_product_cubit.dart';
import 'package:shagaf_ledger/features/products/presentation/cubit/product_cubit/product_cubit.dart';
import 'package:shagaf_ledger/features/orders/data/database/order_items_database.dart';
import 'package:shagaf_ledger/features/orders/data/database/orders_database.dart';
import 'package:shagaf_ledger/features/orders/data/repository/orders_repository_imp.dart';
import 'package:shagaf_ledger/features/orders/domain/repository/orders_repository.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/create_order.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/cancel_order.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/get_order_details.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/get_orders.dart';
import 'package:shagaf_ledger/features/orders/presentation/add_order_cubit/add_order_cubit.dart';
import 'package:shagaf_ledger/features/orders/presentation/order_details_cubit/order_details_cubit.dart';
import 'package:shagaf_ledger/initDependencies/init_local_database.dart';
import 'package:sqflite/sqflite.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final database = await initLocalDatabase();

  serviceLocator.registerLazySingleton<Database>(() => database);
  serviceLocator.registerLazySingleton<AppNotifications>(AppNotifications.new);

  _registerDatabases(database);
  _registerRepositories(database);
  _registerUseCases();
  _registerStateManagement();
}

// -----------------------------------------------------------------------------
// Databases
// -----------------------------------------------------------------------------

void _registerDatabases(Database database) {
  serviceLocator.registerFactory<ProductLocalDatabase>(
    () => ProductLocalDatabase(localDB: database),
  );

  serviceLocator.registerFactory<OrdersDatabase>(
    () => OrdersDatabase(localDB: database),
  );

  serviceLocator.registerFactory<OrderItemsDatabase>(
    () => OrderItemsDatabase(localDB: database),
  );

  serviceLocator.registerLazySingleton<InventoryHistoryDatabase>(
    () => InventoryHistoryDatabase(database: database),
  );

  serviceLocator.registerFactory<ClientsDatabase>(
    () => ClientsDatabase(database: database),
  );

  serviceLocator.registerFactory<ExpensesDatabase>(
    () => ExpensesDatabase(database: database),
  );
}

// -----------------------------------------------------------------------------
// Repositories
// -----------------------------------------------------------------------------

void _registerRepositories(Database database) {
  serviceLocator.registerFactory<ProductsRepository>(
    () => ProductsRepositoryImp(
      productLocalDatabase: serviceLocator<ProductLocalDatabase>(),
      inventoryHistoryDatabase: serviceLocator<InventoryHistoryDatabase>(),
      database: database,
    ),
  );

  serviceLocator.registerFactory<OrdersRepository>(
    () => OrdersRepositoryImp(
      ordersDatabase: serviceLocator<OrdersDatabase>(),
      orderItemsDatabase: serviceLocator<OrderItemsDatabase>(),
      productLocalDatabase: serviceLocator<ProductLocalDatabase>(),
      localDB: database,
    ),
  );

  serviceLocator.registerFactory<InventoryHistoryRepository>(
    () => InventoryHistoryRepositoryImp(
      inventoryHistoryDatabase: serviceLocator<InventoryHistoryDatabase>(),
      productsDatabase: serviceLocator<ProductLocalDatabase>(),
      database: database,
    ),
  );

  serviceLocator.registerFactory<ClientsRepository>(
    () => ClientsRepositoryImp(
      clientsDatabase: serviceLocator<ClientsDatabase>(),
      database: database,
    ),
  );

  serviceLocator.registerFactory<ExpensesRepo>(
    () => ExpensesRepoImp(expensesDatabase: serviceLocator<ExpensesDatabase>()),
  );
}

// -----------------------------------------------------------------------------
// Use cases
// -----------------------------------------------------------------------------

void _registerUseCases() {
  // Products
  serviceLocator.registerFactory<GetActiveProducts>(
    () => GetActiveProducts(
      productsRepository: serviceLocator<ProductsRepository>(),
    ),
  );

  serviceLocator.registerFactory<GetProductById>(
    () => GetProductById(
      productsRepository: serviceLocator<ProductsRepository>(),
    ),
  );

  serviceLocator.registerFactory<AddProduct>(
    () => AddProduct(productsRepository: serviceLocator<ProductsRepository>()),
  );

  serviceLocator.registerFactory<UpdateProduct>(
    () =>
        UpdateProduct(productsRepository: serviceLocator<ProductsRepository>()),
  );

  serviceLocator.registerFactory<ArchiveProduct>(
    () => ArchiveProduct(
      productsRepository: serviceLocator<ProductsRepository>(),
    ),
  );

  serviceLocator.registerFactory<RemoveProductFromArchive>(
    () => RemoveProductFromArchive(
      productsRepository: serviceLocator<ProductsRepository>(),
    ),
  );

  serviceLocator.registerFactory<GetArchivedProducts>(
    () => GetArchivedProducts(
      productsRepository: serviceLocator<ProductsRepository>(),
    ),
  );

  // Orders
  serviceLocator.registerFactory<GetOrders>(
    () => GetOrders(ordersRepository: serviceLocator<OrdersRepository>()),
  );

  serviceLocator.registerFactory<GetNewOrder>(
    () => GetNewOrder(repository: serviceLocator<OrdersRepository>()),
  );

  serviceLocator.registerFactory<GetOrderDetails>(
    () => GetOrderDetails(ordersRepository: serviceLocator<OrdersRepository>()),
  );

  serviceLocator.registerFactory<CreateOrder>(
    () => CreateOrder(ordersRepository: serviceLocator<OrdersRepository>()),
  );

  serviceLocator.registerFactory<CancelOrder>(
    () => CancelOrder(ordersRepository: serviceLocator<OrdersRepository>()),
  );

  serviceLocator.registerFactory<GetClientOrders>(
    () => GetClientOrders(ordersRepository: serviceLocator<OrdersRepository>()),
  );

  // Inventory
  serviceLocator.registerFactory<GetInventoryAdditions>(
    () => GetInventoryAdditions(
      inventoryHistoryRepository: serviceLocator<InventoryHistoryRepository>(),
    ),
  );

  serviceLocator.registerFactory<GetProductAdditions>(
    () => GetProductAdditions(
      inventoryHistoryRepository: serviceLocator<InventoryHistoryRepository>(),
    ),
  );

  serviceLocator.registerFactory<AddInventoryAddition>(
    () => AddInventoryAddition(
      inventoryHistoryRepository: serviceLocator<InventoryHistoryRepository>(),
    ),
  );

  // Clients
  serviceLocator.registerFactory<GetClients>(
    () => GetClients(clientsRepository: serviceLocator<ClientsRepository>()),
  );

  serviceLocator.registerFactory<GetClientDetails>(
    () => GetClientDetails(
      clientsRepository: serviceLocator<ClientsRepository>(),
    ),
  );

  serviceLocator.registerFactory<AddClient>(
    () => AddClient(clientsRepository: serviceLocator<ClientsRepository>()),
  );

  // Expenses
  serviceLocator.registerFactory<GetAllExpense>(
    () => GetAllExpense(expensesRepo: serviceLocator<ExpensesRepo>()),
  );

  serviceLocator.registerFactory<AddExpense>(
    () => AddExpense(expensesRepo: serviceLocator<ExpensesRepo>()),
  );
}

// -----------------------------------------------------------------------------
// BLoCs and Cubits
// -----------------------------------------------------------------------------

void _registerStateManagement() {
  // Products
  serviceLocator.registerFactory<ProductsBloc>(
    () => ProductsBloc(
      getActiveProducts: serviceLocator<GetActiveProducts>(),
      addProduct: serviceLocator<AddProduct>(),
      appNotifications: serviceLocator<AppNotifications>(),
    ),
  );

  serviceLocator.registerFactory<ProductCubit>(
    () => ProductCubit(
      getProductById: serviceLocator<GetProductById>(),
      removeProductFromArchive: serviceLocator<RemoveProductFromArchive>(),
    ),
  );

  serviceLocator.registerFactory<EditProductCubit>(
    () => EditProductCubit(
      updateProduct: serviceLocator<UpdateProduct>(),
      archiveProduct: serviceLocator<ArchiveProduct>(),
    ),
  );

  serviceLocator.registerFactory<ArchivedProductsCubit>(
    () => ArchivedProductsCubit(
      getArchivedProducts: serviceLocator<GetArchivedProducts>(),
    ),
  );

  // Orders
  serviceLocator.registerLazySingleton<OrdersCubit>(
    () => OrdersCubit(
      getOrders: serviceLocator<GetOrders>(),
      getNewOrder: serviceLocator<GetNewOrder>(),
    ),
  );

  serviceLocator.registerFactory<OrderDetailsCubit>(
    () => OrderDetailsCubit(
      getOrderDetails: serviceLocator<GetOrderDetails>(),
      cancelOrder: serviceLocator<CancelOrder>(),
      appNotifications: serviceLocator<AppNotifications>(),
    ),
  );

  serviceLocator.registerFactory<AddOrderCubit>(
    () => AddOrderCubit(
      createOrder: serviceLocator<CreateOrder>(),
      getActiveProducts: serviceLocator<GetActiveProducts>(),
      appNotifications: serviceLocator<AppNotifications>(),
    ),
  );

  serviceLocator.registerFactoryParam<ClientOrdersCubit, int, void>(
    (clientId, _) => ClientOrdersCubit(
      getClientOrders: serviceLocator<GetClientOrders>(),
      clientId: clientId,
    ),
  );

  // Inventory
  serviceLocator.registerFactory<InventoryHistoryCubit>(
    () => InventoryHistoryCubit(
      getInventoryAdditions: serviceLocator<GetInventoryAdditions>(),
      getProductAdditions: serviceLocator<GetProductAdditions>(),
    ),
  );

  serviceLocator.registerFactory<AddInventoryAdditionCubit>(
    () => AddInventoryAdditionCubit(
      addInventoryAddition: serviceLocator<AddInventoryAddition>(),
    ),
  );

  // Clients
  serviceLocator.registerFactory<ClientsCubit>(
    () => ClientsCubit(getClients: serviceLocator<GetClients>()),
  );

  serviceLocator.registerFactory<AddClientCubit>(
    () => AddClientCubit(addClient: serviceLocator<AddClient>()),
  );

  serviceLocator.registerFactoryParam<ClientDetailsCubit, int, void>(
    (clientId, _) => ClientDetailsCubit(
      clientId: clientId,
      getClientDetails: serviceLocator<GetClientDetails>(),
    ),
  );

  // Expenses
  serviceLocator.registerFactory<ExpensesCubit>(
    () => ExpensesCubit(getAllExpense: serviceLocator<GetAllExpense>()),
  );

  serviceLocator.registerFactory<AddExpenseCubit>(
    () => AddExpenseCubit(addExpense: serviceLocator<AddExpense>()),
  );
}
