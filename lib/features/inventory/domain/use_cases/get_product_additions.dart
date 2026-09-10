import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/inventory_addition.dart';
import 'package:shagaf_ledger/features/inventory/domain/repository/inventory_history_repository.dart';

class GetProductAdditions implements UseCases<List<InventoryAddition>, int> {
  final InventoryHistoryRepository _inventoryHistoryRepository;

  GetProductAdditions({required this._inventoryHistoryRepository});

  @override
  Future<Either<Failure, List<InventoryAddition>>> call(int productId) async {
    return await _inventoryHistoryRepository.getProductAdditions(
      productId: productId,
    );
  }
}
