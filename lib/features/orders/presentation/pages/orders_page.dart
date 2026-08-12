import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/app_consts.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/order_tile.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/date_filter_widget.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  DateTime filterOrdersByDay = DateTime.now();

  List<Order> orders = [
    Order(
      id: 0,
      createdAt: DateTime.now(),
      totalPrice: 12,
      items: [
        OrderItem(
          id: 0,
          orderId: 0,
          productId: 1,
          productName: 'productName',
          quantity: 30,
          unitSellingPrice: 30,
        ),
        OrderItem(
          id: 0,
          orderId: 0,
          productId: 1,
          productName: 'sec product',
          quantity: 15,
          unitSellingPrice: 20,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    // TODO: fetch orders from db based on filter
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBar(
        leading: DateFilterWidget(),
        leadingWidth: 150,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0), // Adjust the radius size as needed
          ),
        ),
      ),
      body: orders.isEmpty
          ? Center(
              child: Text(
                'لايوجد طلبات اليوم!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) => OrderTile(order: orders[index]),
            ),

      floatingActionButton: FloatingActionButton(
        heroTag: null,
        elevation: 3,
        shape: CircleBorder(),
        onPressed: () {
          // push the add order page
          context.pushNamed(AppConsts().addNewOrderPage);
        },
        child: Image.asset(
          'lib/core/assets/icons/delivery_box.png',
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          width: 30,
        ),
      ),
    );
  }
}
