import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/products/domain/repository/products_repository.dart';

class AddProduct implements UseCases<int, Product> {
  final ProductsRepository productsRepository;

  AddProduct({required this.productsRepository});

  @override
  Future<Either<Failure, int>> call(Product product) async {
    return await productsRepository.addProduct(product: product);
  }
}
