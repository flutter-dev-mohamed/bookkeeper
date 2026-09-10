import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/inventory_addition.dart';
import 'package:shagaf_ledger/features/inventory/domain/repository/inventory_history_repository.dart';

class AddInventoryAddition implements UseCases<void, InventoryAddition> {
  final InventoryHistoryRepository _inventoryHistoryRepository;

  AddInventoryAddition({required this._inventoryHistoryRepository});

  @override
  Future<Either<Failure, void>> call(
    InventoryAddition inventoryAddition,
  ) async {
    return await _inventoryHistoryRepository.addInventoryAddition(
      inventoryAddition: inventoryAddition,
    );
  }
}
