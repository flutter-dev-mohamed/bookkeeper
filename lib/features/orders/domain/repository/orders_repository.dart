import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/Order_details.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';

abstract interface class OrdersRepository {
  Future<Either<Failure, List<OrderEntity>>> getOrders({required String date});

  Future<Either<Failure, void>> createOrder({
    required OrderEntity order,
    required List<OrderItem> items,
  });

  Future<Either<Failure, OrderDetails>> getOrderDetails({required int orderId});

  Future<Either<Failure, void>> cancelOrder({
    required int orderId,
    required List<OrderItem> items,
  });

  Future<Either<Failure, List<OrderEntity>>> getClientOrders({
    required int clientId,
  });
}
