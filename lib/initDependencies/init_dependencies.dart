import 'package:get_it/get_it.dart';
import 'package:shagaf_ledger/features/inventory/data/database/product_local_database.dart';
import 'package:shagaf_ledger/features/inventory/data/repository/inventory_repository_imp.dart';
import 'package:shagaf_ledger/features/inventory/domain/repository/inventory_repository.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/add_product.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/delete_product.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/get_product_by_id.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/get_products.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/update_product.dart';
import 'package:shagaf_ledger/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:shagaf_ledger/initDependencies/init_local_database.dart';
import 'package:sqflite/sqflite.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // init Local db
  final Database localDatabase = await initLocalDatabase();

  serviceLocator.registerLazySingleton<Database>(() => localDatabase);

  _initInventoryBloc(db: localDatabase);
}

void _initInventoryBloc({required Database db}) {
  serviceLocator.registerLazySingleton<InventoryBloc>(
    () => InventoryBloc(
      getProducts: serviceLocator<GetProducts>(),
      addProduct: serviceLocator<AddProduct>(),
      getProductById: serviceLocator<GetProductById>(),
      updateProduct: serviceLocator<UpdateProduct>(),
      deleteProduct: serviceLocator<DeleteProduct>(),
    ),
  );

  // init inventoryRepository
  serviceLocator.registerFactory<InventoryRepository>(
    () => InventoryRepositoryImp(
      productLocalDatabase: serviceLocator<ProductLocalDatabase>(),
    ),
  );

  // init localDatabase
  serviceLocator.registerFactory<ProductLocalDatabase>(
    () => ProductLocalDatabase(localDB: db),
  );
  // init getProducts
  serviceLocator.registerFactory<GetProducts>(
    () =>
        GetProducts(inventoryRepository: serviceLocator<InventoryRepository>()),
  );

  // init addProduct
  serviceLocator.registerFactory<AddProduct>(
    () =>
        AddProduct(inventoryRepository: serviceLocator<InventoryRepository>()),
  );

  // init getProductById
  serviceLocator.registerFactory<GetProductById>(
    () => GetProductById(
      inventoryRepository: serviceLocator<InventoryRepository>(),
    ),
  );

  // init updateProduct
  serviceLocator.registerFactory<UpdateProduct>(
    () => UpdateProduct(
      inventoryRepository: serviceLocator<InventoryRepository>(),
    ),
  );

  // init deleteProduct
  serviceLocator.registerFactory<DeleteProduct>(
    () => DeleteProduct(
      inventoryRepository: serviceLocator<InventoryRepository>(),
    ),
  );
}
