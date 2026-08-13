import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/functions/try_repo.dart';
import 'package:shagaf_ledger/features/orders/data/database/order_items_database.dart';
import 'package:shagaf_ledger/features/orders/data/database/orders_database.dart';
import 'package:shagaf_ledger/features/orders/data/models/order_entity_model.dart';
import 'package:shagaf_ledger/features/orders/data/models/order_item_model.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/repository/orders_repository.dart';

class OrdersRepositoryImp implements OrdersRepository {
  final OrdersDatabase ordersDatabase;
  final OrderItemsDatabase orderItemsDatabase;

  OrdersRepositoryImp({
    required this.ordersDatabase,
    required this.orderItemsDatabase,
  });

  //  ——————————————————————————————————————————————————————————————————————————  createOrder
  // convert orderEntity to ot orderEntityModel
  // insert the order
  // insert will return the id
  // use the id to insert the order items using map to map all items
  @override
  Future<Either<Failure, void>> createOrder({
    required OrderEntity order,
  }) async {
    return await tryRepo<void>(() async {
      final OrderEntityModel orderModel = OrderEntityModel.fromOrderEntity(
        order,
      );

      final int orderId = await ordersDatabase.createOrder(
        orderMap: orderModel.toMap(),
      );

      orderModel.items.map((item) async {
        final itemModel = OrderItemModel.fromEntity(item);

        await orderItemsDatabase.insertOrderItem(
          orderMap: itemModel.toMap(orderId: orderId),
        );
      });
    });
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders({
    required String date,
  }) async {
    return await tryRepo<List<OrderEntityModel>>(() async {
      final ordersMapList = await ordersDatabase.getOrders(date: date);

      final ordersList = ordersMapList.map((ordersMao) {
        return OrderEntityModel.fromMap(map: ordersMao);
      }).toList();

      return ordersList;
    });
  }
}
