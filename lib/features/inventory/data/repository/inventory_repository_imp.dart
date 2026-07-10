import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/database_exception.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/features/inventory/data/database/local_database.dart';
import 'package:shagaf_ledger/features/inventory/data/models/product_model.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/domain/repository/repository.dart';

class InventoryRepositoryImp implements InventoryRepository {
  final LocalDatabase localDatabase;

  InventoryRepositoryImp({required this.localDatabase});

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    return await _try<List<Product>>(
      () async => await localDatabase.loadProducts(),
    );
  }

  @override
  Future<Either<Failure, int>> addProduct({required Product product}) async {
    return await _try<int>(
      () async => await localDatabase.addProduct(
        productModel: ProductModel.fromProduct(product),
      ),
    );
  }

  @override
  Future<Either<Failure, Product>> getProductById({
    required int productId,
  }) async {
    return await _try<Product>(
      () async => await localDatabase.getProductById(productId: productId),
    );
  }

  @override
  Future<Either<Failure, Product>> updateProduct({required Product product}) {
    final ProductModel productModel = ProductModel.fromProduct(product);
    return _try<Product>(
      () async => await localDatabase.updateProduct(productModel: productModel),
    );
  }

  @override
  Future<Either<Failure, void>> deleteProduct({required int productId}) async {
    return await _try<void>(
      () async => await localDatabase.deleteProduct(productId: productId),
    );
  }

  Future<Either<Failure, T>> _try<T>(Future<T> Function() action) async {
    try {
      return right(await action());
    } on LocalDatabaseException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
