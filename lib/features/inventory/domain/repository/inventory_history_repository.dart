import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/inventory_addition.dart';

abstract interface class InventoryHistoryRepository {
  Future<Either<Failure, List<InventoryAddition>>> getInventoryAdditions();

  Future<Either<Failure, void>> addInventoryAddition({
    required InventoryAddition inventoryAddition,
  });

  Future<Either<Failure, List<InventoryAddition>>> getProductAdditions({
    required int productId,
  });
}
