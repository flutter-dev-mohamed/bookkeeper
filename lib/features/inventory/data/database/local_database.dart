import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/errors/database_exception.dart';
import 'package:shagaf_ledger/core/common/errors/unknown_exception.dart';
import 'package:shagaf_ledger/features/inventory/data/models/product_model.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  final Database localDB;
  static const String productsTable = "products";

  LocalDatabase({required this.localDB});

  // getProducts
  Future<List<ProductModel>> loadProducts() async {
    return _try<List<ProductModel>>(() async {
      final productsMapList = await localDB.query(productsTable);

      final List<ProductModel> productModelList = productsMapList.map((
        productMap,
      ) {
        return ProductModel.fromMap(productMap);
      }).toList();

      return productModelList;
    });
  }

  // addProduct
  Future<int> addProduct({required ProductModel productModel}) async {
    return _try<int>(() async {
      // this returns the raw id or the productId
      return await localDB.insert(productsTable, productModel.toMap());
    });
  }

  // getProductById
  Future<ProductModel> getProductById({required int productId}) async {
    return _try<ProductModel>(() async {
      final List<Map<String, dynamic>> result = await localDB.query(
        productsTable,
        where: 'id = ?',
        whereArgs: [productId],
      );

      if (result.isEmpty) {
        throw Exception('Product with ID $productId not found');
      }

      return ProductModel.fromMap(result.first);
    });
  }

  // updateProduct
  Future<ProductModel> updateProduct({
    required ProductModel productModel,
  }) async {
    return _try<ProductModel>(() async {
      OPrint.g('Updating product: ${productModel}');

      final updateRes = await localDB.update(
        productsTable,
        productModel.toMap(update: true),
        where: 'id = ?',
        whereArgs: [productModel.id],
      );

      OPrint.g('Update affected $updateRes row(s).');

      final fetchRes = await localDB.query(
        productsTable,
        where: "id = ?",
        whereArgs: [productModel.id],
      );

      if (fetchRes.isEmpty) {
        OPrint.r('ERROR: No product found with ID ${productModel.id}');
        throw Exception("Update verification failed.");
      }

      // Using the new toString() implementation
      final updatedProduct = ProductModel.fromMap(fetchRes.first);
      OPrint.g('Successfully retrieved updated product: $updatedProduct');

      return updatedProduct;
    });
  }

  // Future<ProductModel> updateProduct({
  //   required ProductModel productModel,
  // }) async {
  //   return _try<ProductModel>(() async {
  //     final updateRes = await localDB.update(
  //       productsTable,
  //       productModel.toMap(update: true),
  //       where: 'id = ?',
  //       whereArgs: [productModel.id],
  //     );
  //     final fetchRes = await localDB.query(
  //       productsTable,
  //       where: "id = ?",
  //       whereArgs: [productModel.id],
  //     );
  //
  //     return ProductModel.fromMap(fetchRes.first);
  //   });
  // }

  // deleteProduct
  Future<void> deleteProduct({required int productId}) async {
    return _try<void>(() async {
      final res = await localDB.delete(
        productsTable,
        where: 'id = ?',
        whereArgs: [productId],
      );
    });
  }

  Future<T> _try<T>(Future<T> Function() action) async {
    try {
      return action();
    } on DatabaseException catch (e) {
      throw LocalDatabaseException(message: e.toString());
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }
}
