import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/Order_details.dart';
import 'package:shagaf_ledger/features/orders/domain/repository/orders_repository.dart';

class GetOrderDetails implements UseCases<OrderDetails, int> {
  final OrdersRepository ordersRepository;

  GetOrderDetails({required this.ordersRepository});

  @override
  Future<Either<Failure, OrderDetails>> call(int orderId) async {
    return await ordersRepository.getOrderDetails(orderId: orderId);
  }
}
