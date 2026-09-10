import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/products/domain/repository/products_repository.dart';

class ArchiveProduct implements UseCases<void, int> {
  final ProductsRepository productsRepository;

  ArchiveProduct({required this.productsRepository});

  @override
  Future<Either<Failure, void>> call(int productId) async {
    return await productsRepository.archiveProduct(productId: productId);
  }
}
