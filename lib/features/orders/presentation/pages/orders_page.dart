import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/app_consts.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
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

  List<OrderEntity> orders = [
    OrderEntity(
      id: 0,
      createdAt: DateTime.now().toIso8601String(),
      totalPrice: 12,
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
