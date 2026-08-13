import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';

abstract interface class OrdersRepository {
  Future<Either<Failure, List<OrderEntity>>> getOrders({required String date});

  Future<Either<Failure, void>> createOrder({required OrderEntity order});
}
