import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/pages/loading_page.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
import 'package:shagaf_ledger/features/orders/presentation/order_details_cubit/order_details_cubit.dart';

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
    context.read<OrderDetailsCubit>().getOrder(orderId: widget.orderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
      listener: (context, state) {
        if (state is GotOrderDetails) {
          order = state.order;
          items = state.items;
        }
      },

      builder: (context, state) {
        final colorScheme = Theme.of(context).colorScheme;

        // —————————————————————————————————————————————————————————————————————  indicate loading
        if (state is OrderDetailsLoading) {
          return LoadingPage();
        } else
        // —————————————————————————————————————————————————————————————————————  Page UI
        if (state is GotOrderDetails) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;

              context.pop(state.didCancelOrder);
            },
            child: Directionality(
              textDirection: TextDirection.rtl,

              child: Scaffold(
                appBar: AppBar(),

                //
                body: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      // order No. date and status
                      Text(
                        'الطلب رقم ${order.id}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        order.createdAt,
                        style: TextStyle(color: colorScheme.secondary),
                      ),

                      Text(
                        order.status == OrderStatus.completed
                            ? "مكتمل"
                            : "ملغي",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: order.status == OrderStatus.completed
                              ? Colors.green
                              : colorScheme.error,
                        ),
                      ),

                      SizedBox(height: 12),

                      // items list
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
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
                          //  ——————————————————————————————————————————————————————  discount
                          if (order.discountValue > 0)
                            Text(
                              (order.discountType == DiscountType.percentage)
                                  ? '-${order.discountValue}%'
                                  : '-${order.discountValue}',
                            ),
                        ],
                      ),
                      //  ——————————————————————————————————————————————————————————  cancel order button
                      SizedBox(height: 24),
                      if (order.status == OrderStatus.completed)
                        CustomPrimaryButton(
                          text: 'إلغاء الطلب',
                          onPressed: () {
                            // show dialog to worn the user
                            _showCancelDialog(
                              context,
                              onCancelOrder: () {
                                OPrint.lineR('cancel order');
                                context.read<OrderDetailsCubit>().cancelOrder(
                                  orderId: order.id,
                                  items: items,
                                );
                                context.pop();
                              },
                            );
                          },
                          backgroundColor: colorScheme.error,
                          foregroundColor: colorScheme.onError,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // —————————————————————————————————————————————————————————————————————  indicate error
        return ErrorPage();
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

  //  ——————————————————————————————————————————————————————————————————————————  Cancel order dialog
  void _showCancelDialog(
    BuildContext context, {
    required VoidCallback onCancelOrder,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: colorScheme.surface,
            shadowColor: colorScheme.shadow,
            title: Text(
              'تحذير!',
              style: TextStyle(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text('سيتم إلغاء الطلب وإعادة الكميات إلى المخزون.'),
            actions: [
              TextButton(
                onPressed: () => context.pop(),

                child: const Text('تراجع', style: TextStyle(fontSize: 16)),
              ),

              //  ——————————————————————————————————————————————————————————————  cancel order
              MaterialButton(
                onPressed: onCancelOrder,
                color: colorScheme.errorContainer,
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(16),
                ),
                child: Text(
                  'إلغاء الطلب',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
