import 'package:flutter/material.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';

class OrderTile extends StatelessWidget {
  final OrderEntity order;

  const OrderTile({super.key, required this.order});

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
              Text(order.id.toString(), style: TextStyle(fontSize: 16)),
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
