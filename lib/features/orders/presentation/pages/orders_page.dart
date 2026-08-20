import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/app_consts.dart';
import 'package:shagaf_ledger/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
import 'package:shagaf_ledger/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/order_tile.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/date_filter_widget.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  DateTime filterOrdersByDay = DateTime.now();

  List<OrderEntity> orders = [];

  @override
  void initState() {
    context.read<OrdersBloc>().add(
      GetOrdersEvent(day: DateTime.now().toIso8601String().split('T')[0]),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state is OrdersLoaded) {
          setState(() {
            orders = state.orders;
          });
        }
        // if a new order is added or an order deleted refetch the list
        if (state is OrderCreated || state is OrdersSuccess) {
          // communicate to the inventory bloc to  reflect the changes
          context.read<InventoryBloc>().add(LoadProductsEvent());

          //  refetch the orders
          context.read<OrdersBloc>().add(
            GetOrdersEvent(day: DateTime.now().toIso8601String().split('T')[0]),
          );
        }
      },
      child: Scaffold(
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
                itemBuilder: (context, index) =>
                    OrderTile(order: orders[index]),
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
      ),
    );
  }
}
