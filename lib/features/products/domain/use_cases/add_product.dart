import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/products/domain/repository/products_repository.dart';

class AddProduct implements UseCases<int, AddProductParams> {
  final ProductsRepository productsRepository;

  AddProduct({required this.productsRepository});

  @override
  Future<Either<Failure, int>> call(AddProductParams addProductParams) async {
    return await productsRepository.addProduct(
      product: addProductParams.product,
      addedCost: addProductParams.addedCost,
    );
  }
}

class AddProductParams {
  final Product product;
  final double addedCost;

  AddProductParams({required this.product, required this.addedCost});
}
