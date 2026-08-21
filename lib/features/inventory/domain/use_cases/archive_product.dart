import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/inventory/domain/repository/inventory_repository.dart';

class ArchiveProduct implements UseCases<void, int> {
  final InventoryRepository inventoryRepository;

  ArchiveProduct({required this.inventoryRepository});

  @override
  Future<Either<Failure, void>> call(int productId) async {
    return await inventoryRepository.archiveProduct(productId: productId);
  }
}
