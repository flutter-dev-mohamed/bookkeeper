import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/products/domain/repository/products_repository.dart';

class RemoveProductFromArchive implements UseCases<void, int> {
  final ProductsRepository productsRepository;

  RemoveProductFromArchive({required this.productsRepository});

  @override
  Future<Either<Failure, void>> call(int productId) async {
    return await productsRepository.removeProductFromArchive(
      productId: productId,
    );
  }
}
