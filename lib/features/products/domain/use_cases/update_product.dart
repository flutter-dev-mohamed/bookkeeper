import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/products/domain/repository/products_repository.dart';

class UpdateProduct implements UseCases<void, Product> {
  final ProductsRepository productsRepository;

  UpdateProduct({required this.productsRepository});

  @override
  Future<Either<Failure, void>> call(Product product) async {
    return await productsRepository.updateProduct(product: product);
  }
}
