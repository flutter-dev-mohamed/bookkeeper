import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
import 'package:shagaf_ledger/features/orders/domain/repository/orders_repository.dart';

class CreateOrder implements UseCases<void, CreateOrderParams> {
  final OrdersRepository ordersRepository;

  CreateOrder({required this.ordersRepository});

  @override
  Future<Either<Failure, void>> call(CreateOrderParams params) async {
    return await ordersRepository.createOrder(
      order: params.order,
      items: params.items,
    );
  }
}

class CreateOrderParams {
  final OrderEntity order;
  final List<OrderItem> items;

  CreateOrderParams({required this.order, required this.items});
}
