import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/app_consts.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';

class OrderTile extends StatelessWidget {
  final OrderEntity order;

  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppConsts().orderDetails,
          pathParameters: {'orderId': order.id.toString()},
        );
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
