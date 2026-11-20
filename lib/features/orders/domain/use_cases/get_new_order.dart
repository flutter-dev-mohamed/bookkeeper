import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/repository/orders_repository.dart';

class GetNewOrder implements UseCases<OrderEntity, int> {
  final OrdersRepository _repository;

  GetNewOrder({required this._repository});

  @override
  Future<Either<Failure, OrderEntity>> call(int orderId) async =>
      await _repository.getNewOrder(orderId: orderId);
}
