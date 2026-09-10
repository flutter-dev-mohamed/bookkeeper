import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/repository/orders_repository.dart';

class GetOrders implements UseCases<List<OrderEntity>, String> {
  final OrdersRepository ordersRepository;

  GetOrders({required this.ordersRepository});

  @override
  Future<Either<Failure, List<OrderEntity>>> call(String date) async {
    return await ordersRepository.getOrders(date: date);
  }
}
