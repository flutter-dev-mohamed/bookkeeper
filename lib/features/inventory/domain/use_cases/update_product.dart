import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/domain/repository/inventory_repository.dart';

class UpdateProduct implements UseCases<void, Product> {
  final InventoryRepository inventoryRepository;

  UpdateProduct({required this.inventoryRepository});

  @override
  Future<Either<Failure, void>> call(Product product) async {
    return await inventoryRepository.updateProduct(product: product);
  }
}
