import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/app_consts.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/product.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/features/inventory/presentation/bloc/inventory_bloc/inventory_bloc.dart';
import 'package:shagaf_ledger/features/inventory/presentation/widgets/product_tile.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Product> products = [
    Product(
      id: 1,
      name: 'Atomic Habits',
      createdAt: DateTime.now(),
      currentInventory: 13,
      purchasePrice: 12.3,
      sellingPrice: 20,
    ),
    Product(
      id: 2,
      name: 'Harry Potter',
      createdAt: DateTime.now(),
      currentInventory: 13,
      purchasePrice: 12.3,
      sellingPrice: 12,
    ),
    Product(
      id: 3,
      name: 'Clean Code',
      createdAt: DateTime.now(),
      currentInventory: 13,
      purchasePrice: 12.3,
      sellingPrice: 7,
    ),
  ];

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'المخزن',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          ),
          centerTitle: true,
        ),

        // -----------------------------------------------------------------------body
        body: BlocConsumer<InventoryBloc, InventoryState>(
          listener: (context, state) {
            if (state is InventorySuccess) {
              // I only emit InventorySuccess if we deleted a product so reload!
              OPrint.g('InventoryPage: Should reload products list!.');
              context.read<InventoryBloc>().add(LoadProductsEvent());
            }
            if (state is InventoryProductsLoaded) {
              products = state.products;
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) =>
                    ProductTile(product: products[index]),
              ),
            );
          },
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.pushNamed(AppConsts().addProductPage).then((value) {
              // call this after we pop back here to reload a fresh productList from DB
              if (context.mounted) {
                context.read<InventoryBloc>().add(LoadProductsEvent());
              }
            });
          },
          child: Icon(Icons.add_rounded, size: 50),
        ),
      ),
    );
  }
}
