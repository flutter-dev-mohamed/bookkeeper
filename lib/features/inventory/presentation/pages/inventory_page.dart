import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/app_consts.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/product_list.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:shagaf_ledger/features/inventory/presentation/widgets/product_tile.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  void initState() {
    super.initState();

    // triggers the event after first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryBloc>().add(LoadProductsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'المخزن',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        centerTitle: true,
        leading: IconButton.filledTonal(
          tooltip: 'Add product',
          onPressed: () {
            context.pushNamed(AppConsts().addProductPage).then((value) {
              if (context.mounted) {
                context.read<InventoryBloc>().add(LoadProductsEvent());
              }
            });
          },
          icon: const Icon(
            Icons.add_rounded,
            size: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed(AppConsts().archivedProductsPage);
            },
            icon: Icon(Icons.archive_rounded, size: 30),
          ),
        ],
      ),

      // -----------------------------------------------------------------------body
      body: BlocConsumer<InventoryBloc, InventoryState>(
        listener: (context, state) {
          OPrint.line(' Inventory Page Listener state: $state ');
          if (state is InventorySuccess) {
            // InventorySuccess state is emitted on:
            // -  Add product
            context.read<InventoryBloc>().add(LoadProductsEvent());
          }
          if (state is InventoryProductsLoaded) {
            products = state.products;
          }
        },
        builder: (context, state) {
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: products.length,
            itemBuilder: (context, index) =>
                ProductTile(product: products[index]),
          );
        },
      ),
    );
  }
}
