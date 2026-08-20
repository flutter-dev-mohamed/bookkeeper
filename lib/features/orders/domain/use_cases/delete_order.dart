import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/Order_details.dart';
import 'package:shagaf_ledger/features/orders/domain/repository/orders_repository.dart';

class DeleteOrder implements UseCases<void, OrderDetails> {
  final OrdersRepository ordersRepository;

  DeleteOrder({required this.ordersRepository});

  @override
  Future<Either<Failure, void>> call(OrderDetails orderDetails) async {
    return await ordersRepository.deleteOrder(
      orderId: orderDetails.order.id,
      items: orderDetails.items,
    );
  }
}
