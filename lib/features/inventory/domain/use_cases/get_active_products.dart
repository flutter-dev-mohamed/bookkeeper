import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/domain/repository/inventory_repository.dart';

class GetActiveProducts implements UseCases<List<Product>, NoParams> {
  final InventoryRepository inventoryRepository;

  GetActiveProducts({required this.inventoryRepository});

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    return await inventoryRepository.getActiveProducts();
  }
}
