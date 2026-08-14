import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/functions/try_repo.dart';
import 'package:shagaf_ledger/features/inventory/data/database/product_local_database.dart';
import 'package:shagaf_ledger/features/orders/data/database/order_items_database.dart';
import 'package:shagaf_ledger/features/orders/data/database/orders_database.dart';
import 'package:shagaf_ledger/features/orders/data/models/order_entity_model.dart';
import 'package:shagaf_ledger/features/orders/data/models/order_item_model.dart';
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
  // use productId to decrement the inventory
  @override
  Future<Either<Failure, void>> createOrder({
    required OrderEntity order,
    required List<OrderItem> items,
  }) async {
    OPrint.b('Repository: createOrder called with ${items.length} items');
    return await tryRepo<void>(() async {
      // convert entity to model
      final OrderEntityModel orderModel = OrderEntityModel.fromOrderEntity(
        order,
      );

      // make a transaction
      await localDB.transaction((txn) async {
        OPrint.c('Repository: Inserting order header...');
        // insert the order and get the order id
        final int orderId = await ordersDatabase.createOrder(
          orderMap: orderModel.toMap(),
          executor: txn,
        );
        OPrint.g('Repository: Order inserted successfully with ID: $orderId');

        OPrint.c('Repository: Inserting order items...');

        // loop over all items decrement the product inventory and insert to DB
        for (final item in items) {
          // convert from entity to model
          final itemModel = OrderItemModel.fromEntity(item);

          final map = itemModel.toMap(orderId: orderId);

          OPrint.y('Decrementing item $item Inventory');
          await productLocalDatabase.decrementProductInventory(
            productId: item.productId,
            quantity: item.quantity,
            executor: txn,
          );

          OPrint.y('Inserting order item map: $map');
          await orderItemsDatabase.insertOrderItem(
            orderMap: map,
            executor: txn,
          );
        }
        OPrint.g(
          'Repository: All ${items.length} items inserted successfully for order ID: $orderId',
        );
      });
    });
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders({
    required String date,
  }) async {
    OPrint.b('Repository: getOrders called with date: $date');
    return await tryRepo<List<OrderEntityModel>>(() async {
      final ordersMapList = await ordersDatabase.getOrders(date: date);
      OPrint.c(
        'Repository: Fetched ${ordersMapList.length} raw order maps for date: $date',
      );

      final ordersList = ordersMapList.map((ordersMao) {
        try {
          return OrderEntityModel.fromMap(map: ordersMao);
        } catch (e) {
          OPrint.r('Error mapping order map: $e\nData: $ordersMao');
          rethrow;
        }
      }).toList();

      OPrint.g('Repository: Successfully mapped ${ordersList.length} orders');
      return ordersList;
    });
  }
}
