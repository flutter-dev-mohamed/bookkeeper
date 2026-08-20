import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
import 'package:shagaf_ledger/features/orders/domain/repository/orders_repository.dart';

class CancelOrder implements UseCases<void, CancelOrderParams> {
  final OrdersRepository ordersRepository;

  CancelOrder({required this.ordersRepository});

  @override
  Future<Either<Failure, void>> call(
    CancelOrderParams changeOrderStatusParams,
  ) async {
    return await ordersRepository.cancelOrder(
      orderId: changeOrderStatusParams.orderId,
      items: changeOrderStatusParams.items,
    );
  }
}

class CancelOrderParams {
  final int orderId;
  final List<OrderItem> items;

  CancelOrderParams({required this.orderId, required this.items});
}
