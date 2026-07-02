import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/domain/repository/repository.dart';

class GetProductById implements UseCases<Product, int> {
  final InventoryRepository inventoryRepository;

  GetProductById({required this.inventoryRepository});

  @override
  Future<Either<Failure, Product>> call(int productId) async {
    return await inventoryRepository.getProductById(productId: productId);
  }
}
