import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/functions/try_repo.dart';
import 'package:shagaf_ledger/features/products/data/database/product_local_database.dart';
import 'package:shagaf_ledger/features/orders/data/database/order_items_database.dart';
import 'package:shagaf_ledger/features/orders/data/database/orders_database.dart';
import 'package:shagaf_ledger/features/orders/data/models/order_details_model.dart';
import 'package:shagaf_ledger/features/orders/data/models/order_entity_model.dart';
import 'package:shagaf_ledger/features/orders/data/models/order_item_model.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/Order_details.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
import 'package:shagaf_ledger/features/orders/domain/repository/orders_repository.dart';
import 'package:sqflite/sqflite.dart';

class OrdersRepositoryImp implements OrdersRepository {
  final OrdersDatabase ordersDatabase;
  final OrderItemsDatabase orderItemsDatabase;
  final ProductLocalDatabase productLocalDatabase;
  final Database localDB;

  OrdersRepositoryImp({
    required this.ordersDatabase,
    required this.orderItemsDatabase,
    required this.productLocalDatabase,
    required this.localDB,
  });

  //  ——————————————————————————————————————————————————————————————————————————  createOrder
  // convert orderEntity to ot orderEntityModel
  // insert the order
  // insert will return the id
  // use the id to insert the order items using map to map all items
  // use productId to decrement the products
  @override
  Future<Either<Failure, void>> createOrder({
    required OrderEntity order,
    required List<OrderItem> items,
  }) async {
    return await tryRepo<void>(() async {
      // convert entity to model
      final OrderEntityModel orderModel = OrderEntityModel.fromOrderEntity(
        order,
      );

      // make a transaction
      await localDB.transaction((txn) async {
        // insert the order and get the order id
        final int orderId = await ordersDatabase.createOrder(
          orderMap: orderModel.toMap(),
          executor: txn,
        );

        // loop over all items decrement the product products and insert to DB
        for (final item in items) {
          // convert from entity to model
          final itemModel = OrderItemModel.fromEntity(item);

          final map = itemModel.toMap(orderId: orderId);

          await productLocalDatabase.decrementProductInventory(
            productId: item.productId,
            quantity: item.quantity,
            executor: txn,
          );

          await orderItemsDatabase.insertOrderItem(
            orderMap: map,
            executor: txn,
          );
        }
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
        try {
          return OrderEntityModel.fromMap(map: ordersMao);
        } catch (e) {
          rethrow;
        }
      }).toList();

      return ordersList;
    });
  }

  @override
  Future<Either<Failure, OrderDetails>> getOrderDetails({
    required int orderId,
  }) async {
    return await tryRepo<OrderDetailsModel>(() async {
      // get the order
      final orderMap = await ordersDatabase.getOrder(orderId: orderId);
      final order = OrderEntityModel.fromMap(map: orderMap);

      // get the order items list
      final orderItemMapList = await orderItemsDatabase.getOrderItems(
        orderId: orderId,
      );

      final orderItemsList = orderItemMapList.map((itemMap) {
        return OrderItemModel.fromMap(itemMap);
      }).toList();

      // return order details
      final orderDetails = OrderDetailsModel(
        order: order,
        items: orderItemsList,
      );
      return orderDetails;
    });
  }

  @override
  Future<Either<Failure, void>> cancelOrder({
    required int orderId,
    required List<OrderItem> items,
  }) async {
    return await tryRepo<void>(() async {
      await localDB.transaction((txn) async {
        // change order status
        await ordersDatabase.cancelOrder(
          executor: txn,
          orderId: orderId,
          statusNo: OrderStatus.canceled.index,
        );

        // loop over the items and increase their product products
        for (final item in items) {
          await productLocalDatabase.incrementProductInventory(
            productId: item.productId,
            quantity: item.quantity,
            executor: txn,
          );
        }
      });
    });
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getClientOrders({
    required int clientId,
  }) async => tryRepo<List<OrderEntityModel>>(() async {
    final orderMapList = await ordersDatabase.getClientOrders(
      clientId: clientId,
    );

    final ordersList = orderMapList
        .map((orderMap) => OrderEntityModel.fromMap(map: orderMap))
        .toList();

    return ordersList;
  });
}
