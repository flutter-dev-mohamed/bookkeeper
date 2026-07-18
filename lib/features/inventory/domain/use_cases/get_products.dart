import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/domain/repository/inventory_repository.dart';

class GetProducts implements UseCases<List<Product>, NoParams> {
  final InventoryRepository inventoryRepository;

  GetProducts({required this.inventoryRepository});

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    return await inventoryRepository.getProducts();
  }
}
