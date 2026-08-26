import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/functions/try_repo.dart';
import 'package:shagaf_ledger/features/inventory/data/database/inventory_history_database.dart';
import 'package:shagaf_ledger/features/inventory/data/models/inventory_addition_model.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/inventory_addition.dart';
import 'package:shagaf_ledger/features/inventory/domain/repository/inventory_history_repository.dart';
import 'package:shagaf_ledger/features/products/data/database/product_local_database.dart';
import 'package:sqflite/sqflite.dart';

class InventoryHistoryRepositoryImp implements InventoryHistoryRepository {
  final InventoryHistoryDatabase _inventoryHistoryDatabase;
  final ProductLocalDatabase _productsDatabase;
  final Database _database;

  InventoryHistoryRepositoryImp({
    required this._inventoryHistoryDatabase,
    required this._productsDatabase,
    required this._database,
  });

  @override
  Future<Either<Failure, List<InventoryAddition>>>
  getInventoryAdditions() async =>
      await tryRepo<List<InventoryAdditionModel>>(() async {
        final additionsMapsList = await _inventoryHistoryDatabase
            .getInventoryAdditions();

        final additionsList = additionsMapsList.map((additionsMap) {
          return InventoryAdditionModel.fromMap(additionsMap);
        }).toList();

        return additionsList;
      });

  @override
  Future<Either<Failure, void>> addInventoryAddition({
    required InventoryAddition inventoryAddition,
  }) async => tryRepo<void>(() async {
    final addition = InventoryAdditionModel.fromEntity(inventoryAddition);
    await _database.transaction((txn) async {
      final inventoryRes = await _inventoryHistoryDatabase.addInventoryAddition(
        additionMap: addition.toMap(),
        executor: txn,
      );

      final productsRes = await _productsDatabase.updateProductInventory(
        executor: txn,
        productId: addition.productId,
        quantity: addition.quantity,
        sellingPrice: addition.unitSellingPrice,
        purchasePrice: addition.unitPurchasePrice,
      );
    });
  });

  @override
  Future<Either<Failure, List<InventoryAddition>>> getProductAdditions({
    required int productId,
  }) async => tryRepo<List<InventoryAddition>>(() async {
    final additionsMapsList = await _inventoryHistoryDatabase
        .getProductAdditions(productId: productId);

    final additionsList = additionsMapsList.map((additionsMap) {
      return InventoryAdditionModel.fromMap(additionsMap);
    }).toList();

    return additionsList;
  });
}
