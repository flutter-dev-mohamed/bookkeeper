import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/presentation/client_orders_cubit/client_orders_cubit.dart';

class ClientOrdersCard extends StatelessWidget {
  const ClientOrdersCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientOrdersCubit, ClientOrdersState>(
      builder: (context, state) {
        if (state is ClientOrdersLoading ||
            (state is GotClientOrders && state.orders.isEmpty)) {
          return SizedBox.shrink();
        }

        return _card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'طلبات',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 14),

                (state is GotClientOrders)
                    ? _ordersListBuilder(
                        orders: state.orders,
                        colorScheme: Theme.of(context).colorScheme,
                        theme: Theme.of(context),
                      )
                    // —————————————————————————————————————————————————————————  error
                    : SizedBox(
                        height: 100,
                        child: Center(
                          child: Image.asset(
                            'lib/core/assets/icons/error.png',
                            width: 80,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _card({required Widget child}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: child,
    );
  }

  Widget _ordersListBuilder({
    required List<OrderEntity> orders,
    required ColorScheme colorScheme,
    required ThemeData theme,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 700),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: colorScheme.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Order icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.receipt_long_outlined,
                      color: order.status == OrderStatus.completed
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Order information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الطلب #${order.id}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Row(
                          children: [
                            Icon(
                              Icons.schedule_outlined,
                              size: 15,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              order.createdAt,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Total
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'المجموع',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${order.totalPrice}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 4),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
