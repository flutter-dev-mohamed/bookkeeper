import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';

abstract interface class InventoryRepository {
  Future<Either<Failure, List<Product>>> getProducts();

  Future<Either<Failure, Product>> getProductById({required int productId});

  Future<Either<Failure, int>> addProduct({required Product product});

  Future<Either<Failure, Product>> updateProduct({required Product product});

  Future<Either<Failure, void>> deleteProduct({required int productId});

  Future<Either<Failure, void>> decrementInventory({
    required int productId,
    required int quantity,
  });
}
