import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/app_consts.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/pages/loading_page.dart';
import 'package:shagaf_ledger/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:shagaf_ledger/features/inventory/presentation/widgets/product_tile.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  void loadProductsList(BuildContext context) =>
      context.read<InventoryBloc>().add(LoadProductsEvent());

  void _navigateToArchivedProductsPage(BuildContext context) async {
    final changed = await context.pushNamed(AppConsts().archivedProductsPage);

    if (changed == true && context.mounted) {
      loadProductsList(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InventoryBloc, InventoryState>(
      listener: (context, state) {
        OPrint.lineC(' Inventory Page Listener state: $state ');
        if (state is InventorySuccess) {
          // InventorySuccess state is emitted on:
          // -  Add product
          loadProductsList(context);
        }
      },
      builder: (context, state) {
        if (state is InventoryLoading) {
          return LoadingPage();
        }

        //  ————————————————————————————————————————————————————————————————————  Page UI
        if (state is InventoryProductsLoaded) {
          final products = state.products;
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
                      loadProductsList(context);
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
                  onPressed: () => _navigateToArchivedProductsPage(context),
                  icon: Icon(Icons.archive_rounded, size: 30),
                ),
              ],
            ),

            body: ListView.builder(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: products.length,
              itemBuilder: (context, index) => ProductTile(
                product: products[index],
                onProductDetailsChange: () => loadProductsList(context),
              ),
            ),
          );
        }

        // if state isn't: Loading or ProductsLoaded than we have an error
        return ErrorPage();
      },
    );
  }
}
