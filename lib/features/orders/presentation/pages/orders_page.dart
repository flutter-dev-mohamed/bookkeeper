import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/app_consts.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/pages/loading_page.dart';
import 'package:shagaf_ledger/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
import 'package:shagaf_ledger/features/orders/presentation/orders_bloc/orders_bloc.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/order_tile.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/date_filter_widget.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return LoadingPage();
        }

        if (state is OrdersLoaded) {
          final orders = state.orders;

          return Scaffold(
            appBar: AppBar(
              leading: DateFilterWidget(),
              leadingWidth: 150,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(
                    20.0,
                  ), // Adjust the radius size as needed
                ),
              ),
            ),

            body: orders.isEmpty
                ? Center(
                    child: Text(
                      'لايوجد طلبات اليوم!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: orders.length,
                    itemBuilder: (context, index) => OrderTile(
                      order: orders[index],
                      updateOrdersList: () {
                        if (context.mounted) {
                          context.read<OrdersBloc>().add(
                            GetOrdersEvent(day: state.dateFilter),
                          );
                        }
                      },
                    ),
                  ),

            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: _shouldShowAddOrderButton(state)
                ? FloatingActionButton.extended(
                    heroTag: null,
                    elevation: 3,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.secondaryContainer,
                    foregroundColor: Theme.of(
                      context,
                    ).colorScheme.onSecondaryContainer,
                    onPressed: () async {
                      final didAddOrder = await context.pushNamed(
                        AppConsts().addNewOrderPage,
                      );

                      if (context.mounted && didAddOrder == true) {
                        context.read<OrdersBloc>().add(
                          GetOrdersEvent(day: state.dateFilter),
                        );
                      }
                    },
                    icon: Image.asset(
                      'lib/core/assets/icons/delivery_box.png',
                      width: 24,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    label: const Text('طلب جديد'),
                  )
                : null,
          );
        }

        // in case of an error
        return ErrorPage();
      },
    );
  }

  bool _shouldShowAddOrderButton(OrdersState state) {
    final now = DateTime.now();

    return state is OrdersLoaded &&
        state.dateFilter.year == now.year &&
        state.dateFilter.month == now.month &&
        state.dateFilter.day == now.day;
  }
}
