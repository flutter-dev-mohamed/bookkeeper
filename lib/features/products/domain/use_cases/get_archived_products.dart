import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/products/domain/repository/products_repository.dart';

class GetArchivedProducts implements UseCases<List<Product>, NoParams> {
  final ProductsRepository productsRepository;

  GetArchivedProducts({required this.productsRepository});

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    return await productsRepository.getArchivedProducts();
  }
}
