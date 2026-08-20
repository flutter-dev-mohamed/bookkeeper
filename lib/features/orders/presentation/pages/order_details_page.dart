import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_text_field.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/Order_details.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
import 'package:shagaf_ledger/features/orders/presentation/bloc/orders_bloc.dart';

class OrderDetailsPage extends StatefulWidget {
  final int orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  OrderEntity order = OrderEntity(
    id: 0,
    createdAt: DateTime.now().toIso8601String(),
    totalPrice: 0,
    originalPrice: 0,
    discountType: DiscountType.amount,
    discountValue: 0,
  );
  List<OrderItem> items = [];

  @override
  void initState() {
    context.read<OrdersBloc>().add(
      GetOrderDetailsEvent(orderId: widget.orderId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state is OrdersGotOrderDetails) {
          order = state.order;
          items = state.items;
        }
        if (state is OrdersSuccess) {
          context.pop();
        }
      },

      builder: (context, state) {
        final colorScheme = Theme.of(context).colorScheme;
        return Directionality(
          textDirection: TextDirection.rtl,

          child: Scaffold(
            appBar: AppBar(
              title: Text('طلب رقم ${order.id}'),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    // TODO: delete the order
                    context.read<OrdersBloc>().add(
                      DeleteOrderEvent(
                        orderDetails: OrderDetails(order: order, items: items),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),

            //
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  _itemsListBuilder(colorScheme),

                  //  ——————————————————————————————————————————————————————————  note
                  if (order.note.isNotEmpty)
                    Padding(
                      padding: EdgeInsetsGeometry.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //
                          Text(
                            'ملاحظة',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            order.note,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(height: 5, color: colorScheme.secondary),
                  ),
                  //  ——————————————————————————————————————————————————————————  total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              //
                              text: order.totalPrice.toString(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            TextSpan(text: " "),

                            if (order.discountValue > 0)
                              TextSpan(
                                text: order.originalPrice.toString(),
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                      ),
                      //  ——————————————————————————————————————————————————————————  discount
                      Text(
                        (order.discountType == DiscountType.percentage)
                            ? '-${order.discountValue}%'
                            : '-${order.discountValue}',
                      ),
                    ],
                  ),
                  //
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //  ——————————————————————————————————————————————————————————————————————————  _itemsListBuilder: builds the items list
  Widget _itemsListBuilder(ColorScheme colorScheme) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,

      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(top: 6),
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    items[index].productName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('IQD ${items[index].unitSellingPrice}'),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'x${items[index].quantity}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                ),
                Text('IQD ${items[index].totalPrice}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
