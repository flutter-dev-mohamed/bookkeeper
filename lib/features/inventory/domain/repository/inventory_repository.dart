import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';

abstract interface class InventoryRepository {
  Future<Either<Failure, List<Product>>> getActiveProducts();

  Future<Either<Failure, Product>> getProductById({required int productId});

  Future<Either<Failure, int>> addProduct({required Product product});

  Future<Either<Failure, void>> updateProduct({required Product product});

  Future<Either<Failure, void>> archiveProduct({required int productId});

  Future<Either<Failure, List<Product>>> getArchivedProducts();

  Future<Either<Failure, void>> removeProductFromArchive({
    required int productId,
  });
}
