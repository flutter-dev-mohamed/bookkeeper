import 'package:get_it/get_it.dart';
import 'package:shagaf_ledger/features/clients/data/database/clients_database.dart';
import 'package:shagaf_ledger/features/clients/data/repository/clients_repository_imp.dart';
import 'package:shagaf_ledger/features/clients/domain/repository/clients_repository.dart';
import 'package:shagaf_ledger/features/clients/domain/use_cases/add_client.dart';
import 'package:shagaf_ledger/features/clients/domain/use_cases/get_clients.dart';
import 'package:shagaf_ledger/features/clients/presentation/state_management/add_client_cubit/add_client_cubit.dart';
import 'package:shagaf_ledger/features/clients/presentation/state_management/clients_cubit/clients_cubit.dart';
import 'package:shagaf_ledger/features/inventory/data/database/inventory_history_database.dart';
import 'package:shagaf_ledger/features/inventory/data/repository/inventory_history_repository_imp.dart';
import 'package:shagaf_ledger/features/inventory/domain/repository/inventory_history_repository.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/add_inventory_addition.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/get_inventory_additions.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/get_product_additions.dart';
import 'package:shagaf_ledger/features/inventory/presentation/state/add_inventory_addition_cubit/add_inventory_addition_cubit.dart';
import 'package:shagaf_ledger/features/inventory/presentation/state/inventory_history_cubit/inventory_history_cubit.dart';
import 'package:shagaf_ledger/features/orders/domain/use_cases/get_client_orders.dart';
import 'package:shagaf_ledger/features/orders/presentation/client_orders_cubit/client_orders_cubit.dart';
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
import 'package:shagaf_ledger/features/orders/presentation/orders_bloc/orders_bloc.dart';
import 'package:shagaf_ledger/features/orders/presentation/order_details_cubit/order_details_cubit.dart';
import 'package:shagaf_ledger/initDependencies/init_local_database.dart';
import 'package:sqflite/sqflite.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // init Local db
  final Database localDatabase = await initLocalDatabase();

  serviceLocator.registerLazySingleton<Database>(() => localDatabase);

  _initProductsBloc(db: localDatabase);
  _initOrdersBloc(db: localDatabase);
  _initOrderDetailsCubit();
  _initProductCubit();
  _initAddOrderCubit();
  _initEditProductCubit();
  _initArchivedProductsCubit();
  _initInventoryHistoryCubit(db: localDatabase);
  _initAddInventoryAdditionCubit();
  _initClientsCubit(db: localDatabase);
  _initAddClientCubit();
  _initClientOrdersCubit();
}

void _initProductsBloc({required Database db}) {
  serviceLocator.registerFactory<ProductsBloc>(
    () => ProductsBloc(
      getActiveProducts: serviceLocator<GetActiveProducts>(),
      addProduct: serviceLocator<AddProduct>(),
    ),
  );

  // init inventoryRepository
  serviceLocator.registerFactory<ProductsRepository>(
    () => ProductsRepositoryImp(
      productLocalDatabase: serviceLocator<ProductLocalDatabase>(),
      inventoryHistoryDatabase: serviceLocator<InventoryHistoryDatabase>(),
      database: db,
    ),
  );

  // init localDatabase
  serviceLocator.registerFactory<ProductLocalDatabase>(
    () => ProductLocalDatabase(localDB: db),
  );
  // init getProducts
  serviceLocator.registerFactory<GetActiveProducts>(
    () => GetActiveProducts(
      productsRepository: serviceLocator<ProductsRepository>(),
    ),
  );

  // init addProduct
  serviceLocator.registerFactory<AddProduct>(
    () => AddProduct(productsRepository: serviceLocator<ProductsRepository>()),
  );
}

void _initOrdersBloc({required Database db}) {
  serviceLocator.registerLazySingleton<OrdersBloc>(
    () => OrdersBloc(getOrders: serviceLocator<GetOrders>()),
  );

  serviceLocator.registerFactory<CancelOrder>(
    () => CancelOrder(ordersRepository: serviceLocator<OrdersRepository>()),
  );
  serviceLocator.registerFactory<GetOrderDetails>(
    () => GetOrderDetails(ordersRepository: serviceLocator<OrdersRepository>()),
  );

  serviceLocator.registerFactory<GetOrders>(
    () => GetOrders(ordersRepository: serviceLocator<OrdersRepository>()),
  );

  serviceLocator.registerFactory<OrdersRepository>(
    () => OrdersRepositoryImp(
      ordersDatabase: serviceLocator<OrdersDatabase>(),
      orderItemsDatabase: serviceLocator<OrderItemsDatabase>(),
      productLocalDatabase: serviceLocator<ProductLocalDatabase>(),
      localDB: db,
    ),
  );

  serviceLocator.registerFactory<OrdersDatabase>(
    () => OrdersDatabase(localDB: db),
  );

  serviceLocator.registerFactory<OrderItemsDatabase>(
    () => OrderItemsDatabase(localDB: db),
  );
}

void _initOrderDetailsCubit() {
  serviceLocator.registerFactory<OrderDetailsCubit>(
    () => OrderDetailsCubit(
      getOrderDetails: serviceLocator<GetOrderDetails>(),
      cancelOrder: serviceLocator<CancelOrder>(),
    ),
  );
}

void _initProductCubit() {
  serviceLocator.registerFactory<ProductCubit>(
    () => ProductCubit(
      getProductById: serviceLocator<GetProductById>(),
      removeProductFromArchive: serviceLocator<RemoveProductFromArchive>(),
    ),
  );

  serviceLocator.registerFactory<RemoveProductFromArchive>(
    () => RemoveProductFromArchive(
      productsRepository: serviceLocator<ProductsRepository>(),
    ),
  );

  // init getProductById
  serviceLocator.registerFactory<GetProductById>(
    () => GetProductById(
      productsRepository: serviceLocator<ProductsRepository>(),
    ),
  );
}

void _initAddOrderCubit() {
  serviceLocator.registerFactory<AddOrderCubit>(
    () => AddOrderCubit(
      createOrder: serviceLocator<CreateOrder>(),
      getActiveProducts:
          serviceLocator<
            GetActiveProducts
          >(), //  already declared in with products bloc
    ),
  );

  serviceLocator.registerFactory<CreateOrder>(
    () => CreateOrder(ordersRepository: serviceLocator<OrdersRepository>()),
  );
}

void _initEditProductCubit() {
  serviceLocator.registerFactory<EditProductCubit>(
    () => EditProductCubit(
      updateProduct: serviceLocator<UpdateProduct>(),
      archiveProduct: serviceLocator<ArchiveProduct>(),
    ),
  );

  // init updateProduct
  serviceLocator.registerFactory<UpdateProduct>(
    () =>
        UpdateProduct(productsRepository: serviceLocator<ProductsRepository>()),
  );

  // init deleteProduct
  serviceLocator.registerFactory<ArchiveProduct>(
    () => ArchiveProduct(
      productsRepository: serviceLocator<ProductsRepository>(),
    ),
  );
}

void _initArchivedProductsCubit() {
  serviceLocator.registerFactory<ArchivedProductsCubit>(
    () => ArchivedProductsCubit(
      getArchivedProducts: serviceLocator<GetArchivedProducts>(),
    ),
  );

  serviceLocator.registerFactory<GetArchivedProducts>(
    () => GetArchivedProducts(
      productsRepository: serviceLocator<ProductsRepository>(),
    ),
  );
}

void _initInventoryHistoryCubit({required Database db}) {
  serviceLocator.registerFactory<InventoryHistoryCubit>(
    () => InventoryHistoryCubit(
      getInventoryAdditions: serviceLocator<GetInventoryAdditions>(),
      getProductAdditions: serviceLocator<GetProductAdditions>(),
    ),
  );

  serviceLocator.registerFactory<GetProductAdditions>(
    () => GetProductAdditions(
      inventoryHistoryRepository: serviceLocator<InventoryHistoryRepository>(),
    ),
  );

  serviceLocator.registerFactory<GetInventoryAdditions>(
    () => GetInventoryAdditions(
      inventoryHistoryRepository: serviceLocator<InventoryHistoryRepository>(),
    ),
  );
  serviceLocator.registerFactory<InventoryHistoryRepository>(
    () => InventoryHistoryRepositoryImp(
      inventoryHistoryDatabase: serviceLocator<InventoryHistoryDatabase>(),
      productsDatabase: serviceLocator<ProductLocalDatabase>(),
      database: db,
    ),
  );
  serviceLocator.registerLazySingleton<InventoryHistoryDatabase>(
    () => InventoryHistoryDatabase(database: db),
  );
}

void _initAddInventoryAdditionCubit() {
  serviceLocator.registerFactory<AddInventoryAdditionCubit>(
    () => AddInventoryAdditionCubit(
      addInventoryAddition: serviceLocator<AddInventoryAddition>(),
    ),
  );

  serviceLocator.registerFactory<AddInventoryAddition>(
    () => AddInventoryAddition(
      inventoryHistoryRepository: serviceLocator<InventoryHistoryRepository>(),
    ),
  );
}

void _initClientsCubit({required Database db}) {
  serviceLocator.registerFactory<ClientsCubit>(
    () => ClientsCubit(getClients: serviceLocator<GetClients>()),
  );

  serviceLocator.registerFactory<GetClients>(
    () => GetClients(clientsRepository: serviceLocator<ClientsRepository>()),
  );
  serviceLocator.registerFactory<ClientsRepository>(
    () => ClientsRepositoryImp(
      clientsDatabase: serviceLocator<ClientsDatabase>(),
      database: db,
    ),
  );
  serviceLocator.registerFactory<ClientsDatabase>(
    () => ClientsDatabase(database: db),
  );
}

void _initAddClientCubit() {
  serviceLocator.registerFactory<AddClientCubit>(
    () => AddClientCubit(addClient: serviceLocator<AddClient>()),
  );

  serviceLocator.registerFactory<AddClient>(
    () => AddClient(clientsRepository: serviceLocator<ClientsRepository>()),
  );
}

void _initClientOrdersCubit() {
  serviceLocator.registerFactoryParam<ClientOrdersCubit, int, void>(
    (clientId, _) => ClientOrdersCubit(
      getClientOrders: serviceLocator<GetClientOrders>(),
      clientId: clientId,
    ),
  );

  serviceLocator.registerFactory<GetClientOrders>(
    () => GetClientOrders(ordersRepository: serviceLocator<OrdersRepository>()),
  );
}
