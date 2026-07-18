import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/inventory/domain/repository/inventory_repository.dart';

class DeleteProduct implements UseCases<void, int> {
  final InventoryRepository inventoryRepository;

  DeleteProduct({required this.inventoryRepository});

  @override
  Future<Either<Failure, void>> call(int productId) async {
    return await inventoryRepository.deleteProduct(productId: productId);
  }
}
