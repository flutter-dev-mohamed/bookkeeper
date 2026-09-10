import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/pages/loading_page.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_app_bar.dart';
import 'package:shagaf_ledger/features/products/presentation/cubit/archived_products_cubit/archived_products_cubit.dart';
import 'package:shagaf_ledger/features/products/presentation/widgets/product_tile.dart';

class ArchivedProductsPage extends StatelessWidget {
  const ArchivedProductsPage({super.key});

  void _onProductsListChanges(BuildContext context) => context
      .read<ArchivedProductsCubit>()
      .loadArchivedProducts(didChanged: true);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArchivedProductsCubit, ArchivedProductsState>(
      builder: (context, state) {
        //  ————————————————————————————————————————————————————————————————————  loading
        if (state is ArchivedProductsLoading) return LoadingPage();

        //  ————————————————————————————————————————————————————————————————————  Page UI
        if (state is GotArchivedProducts) {
          final products = state.products;

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;

              context.pop(state.didChanged);
            },
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: CustomAppBar(
                  title: Text(
                    'الأرشيف',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                ),

                body: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: products.length,
                  itemBuilder: (context, index) => ProductTile(
                    product: products[index],
                    onProductDetailsChange: () async {
                      _onProductsListChanges(context);
                    },
                  ),
                ),
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
