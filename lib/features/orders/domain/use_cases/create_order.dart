import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/repository/orders_repository.dart';

class CreateOrder implements UseCases<void, OrderEntity> {
  final OrdersRepository ordersRepository;

  CreateOrder({required this.ordersRepository});

  @override
  Future<Either<Failure, void>> call(OrderEntity order) async {
    return await ordersRepository.createOrder(order: order);
  }
}
