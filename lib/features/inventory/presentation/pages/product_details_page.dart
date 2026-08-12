import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:shagaf_ledger/features/inventory/presentation/widgets/edit_product_screen.dart';
import 'package:shagaf_ledger/features/inventory/presentation/widgets/product_details_screen.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // fetch product from db
      context.read<InventoryBloc>().add(
        GetProductByIdEvent(productId: widget.productId),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InventoryBloc, InventoryState>(
      listener: (context, state) {
        OPrint.c('Checking if reload is needed...');
        // when updating a product we need to reload the products list in the inventory page
        // so we  get the InventoryProductsLoaded so we need to reload the product again
        if (state is InventoryProductsLoaded) {
          OPrint.c('Reload is needed... RELOADING...');
          OPrint.c('Reload the product details');
          context.read<InventoryBloc>().add(
            GetProductByIdEvent(productId: widget.productId),
          );
        }
      },
      builder: (context, state) {
        OPrint.y(state);
        OPrint.y('product id: ${widget.productId}');

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: state is InventoryEditProduct
                ? Text(
                    'تعديل',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  )
                : null,
          ),
          body: state is InventoryLoading
              ? Center(child: CircularProgressIndicator()) // loading indicator
              : state is InventoryGotProductById
              ? ProductDetailsScreen(product: state.product)
              : state is InventoryEditProduct
              ? EditProductScreen(product: state.product)
              : ErrorPage(),
        );
      },
    );
  }
}
