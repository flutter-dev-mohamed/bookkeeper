import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/repository/orders_repository.dart';

class GetClientOrders implements UseCases<List<OrderEntity>, int> {
  final OrdersRepository _ordersRepository;

  GetClientOrders({required this._ordersRepository});

  @override
  Future<Either<Failure, List<OrderEntity>>> call(int clientId) async =>
      await _ordersRepository.getClientOrders(clientId: clientId);
}
