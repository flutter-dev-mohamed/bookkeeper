import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/functions/try_repo.dart';
import 'package:shagaf_ledger/features/products/data/database/product_local_database.dart';
import 'package:shagaf_ledger/features/products/data/models/product_model.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/products/domain/repository/products_repository.dart';

class ProductsRepositoryImp implements ProductsRepository {
  final ProductLocalDatabase productLocalDatabase;

  ProductsRepositoryImp({required this.productLocalDatabase});

  @override
  Future<Either<Failure, List<Product>>> getActiveProducts() async {
    return await tryRepo<List<ProductModel>>(() async {
      // fetch the maps list
      final productsMapsList = await productLocalDatabase.loadActiveProducts();

      // convert maps list
      final productsList = productsMapsList.map((productMap) {
        return ProductModel.fromMap(productMap);
      }).toList();

      // return the products list
      return productsList;
    });
  }

  @override
  Future<Either<Failure, int>> addProduct({required Product product}) async {
    return await tryRepo<int>(
      () async => await productLocalDatabase.addProduct(
        productMap: ProductModel.fromProduct(product).toMap(),
      ),
    );
  }

  @override
  Future<Either<Failure, Product>> getProductById({
    required int productId,
  }) async {
    return await tryRepo<Product>(() async {
      final productMap = await productLocalDatabase.getProductById(
        productId: productId,
      );

      final product = ProductModel.fromMap(productMap);

      return product;
    });
  }

  @override
  Future<Either<Failure, void>> updateProduct({
    required Product product,
  }) async {
    final ProductModel productModel = ProductModel.fromProduct(product);
    return await tryRepo<void>(() async {
      return await productLocalDatabase.updateProduct(
        productId: productModel.id,
        productMap: productModel.toMap(update: true),
      );
    });
  }

  @override
  Future<Either<Failure, void>> archiveProduct({required int productId}) async {
    return await tryRepo<void>(
      () async =>
          await productLocalDatabase.archiveProduct(productId: productId),
    );
  }

  @override
  Future<Either<Failure, List<Product>>> getArchivedProducts() async =>
      await tryRepo<List<Product>>(() async {
        final productsMapsList = await productLocalDatabase
            .loadArchivedProducts();

        final productsList = productsMapsList
            .map((productMap) => ProductModel.fromMap(productMap))
            .toList();

        return productsList;
      });

  @override
  Future<Either<Failure, void>> removeProductFromArchive({
    required int productId,
  }) async {
    return await tryRepo<void>(
      () async => await productLocalDatabase.removeProductFromArchive(
        productId: productId,
      ),
    );
  }
}
