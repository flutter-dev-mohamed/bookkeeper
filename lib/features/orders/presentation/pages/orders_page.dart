import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/app_navigator/app_navigator.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/pages/loading_page.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_app_bar.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_fab.dart';
import 'package:shagaf_ledger/features/orders/presentation/orders_bloc/orders_bloc.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/order_tile.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/date_filter_widget.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return LoadingPage();
        }

        if (state is OrdersLoaded) {
          final orders = state.orders;

          return Scaffold(
            appBar: CustomAppBar(
              title: const Text(
                'الطلبات',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              leading: DateFilterWidget(),
              leadingWidth: 100,
            ),
            extendBodyBehindAppBar: true,

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
                    padding: const EdgeInsets.symmetric(vertical: 120),
                    itemCount: orders.length,
                    itemBuilder: (context, index) => OrderTile(
                      order: orders[index],
                      updateOrdersList: () {
                        if (context.mounted) {
                          context.read<OrdersBloc>().add(UpdateOrdersEvent());
                        }
                      },
                    ),
                  ),

            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: _shouldShowAddOrderButton(state)
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    child: ClipRRect(
                      child: CustomFab(
                        onPressed: () async {
                          final didAddOrder = await AppNavigator()
                              .navToAddOrderPage(context);

                          if (context.mounted && didAddOrder == true) {
                            context.read<OrdersBloc>().add(UpdateOrdersEvent());
                          }
                        },
                        child: Image.asset(
                          'lib/core/assets/icons/delivery_box.png',
                          width: 24,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
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
