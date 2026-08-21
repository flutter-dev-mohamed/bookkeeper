import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/database_exception.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/functions/try_repo.dart';
import 'package:shagaf_ledger/features/inventory/data/database/product_local_database.dart';
import 'package:shagaf_ledger/features/inventory/data/models/product_model.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/domain/repository/inventory_repository.dart';

class InventoryRepositoryImp implements InventoryRepository {
  final ProductLocalDatabase productLocalDatabase;

  InventoryRepositoryImp({required this.productLocalDatabase});

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    return await tryRepo<List<Product>>(
      () async => await productLocalDatabase.loadProducts(),
    );
  }

  @override
  Future<Either<Failure, int>> addProduct({required Product product}) async {
    return await tryRepo<int>(
      () async => await productLocalDatabase.addProduct(
        productModel: ProductModel.fromProduct(product),
      ),
    );
  }

  @override
  Future<Either<Failure, Product>> getProductById({
    required int productId,
  }) async {
    return await tryRepo<Product>(
      () async =>
          await productLocalDatabase.getProductById(productId: productId),
    );
  }

  @override
  Future<Either<Failure, Product>> updateProduct({required Product product}) {
    final ProductModel productModel = ProductModel.fromProduct(product);
    return tryRepo<Product>(
      () async =>
          await productLocalDatabase.updateProduct(productModel: productModel),
    );
  }

  @override
  Future<Either<Failure, void>> archiveProduct({required int productId}) async {
    return await tryRepo<void>(
      () async =>
          await productLocalDatabase.archiveProduct(productId: productId),
    );
  }
}
