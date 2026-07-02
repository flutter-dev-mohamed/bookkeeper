import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/domain/repository/repository.dart';

class AddProduct implements UseCases<int, Product> {
  final InventoryRepository inventoryRepository;

  AddProduct({required this.inventoryRepository});

  @override
  Future<Either<Failure, int>> call(Product product) async {
    return await inventoryRepository.addProduct(product: product);
  }
}
