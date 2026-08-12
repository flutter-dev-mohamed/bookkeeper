import 'package:flutter/material.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order.dart';

class OrderTile extends StatelessWidget {
  final Order order;

  const OrderTile({super.key, required this.order});

  String _getOrderTitle() {
    final item = order.items.map((item) {
      return '${item.productName} ${item.quantity}x';
    });
    return item.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: nav to order details page
        OPrint.m('ADD FUNCTIONALITY');
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_getOrderTitle(), style: TextStyle(fontSize: 16)),
              Text(
                'المجموع: ${order.totalPrice}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
