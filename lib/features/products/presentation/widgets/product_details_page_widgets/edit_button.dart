import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/app_consts.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/products/presentation/cubit/product_cubit/product_cubit.dart';
import 'package:shagaf_ledger/features/products/presentation/navigation_return.dart';

class EditButton extends StatelessWidget {
  final Product product;

  const EditButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final respond = await context.pushNamed(
          AppConsts().editProductPage,
          extra: product,
          pathParameters: {"productId": product.id.toString()},
        );

        if (respond == NavigationReturn.productUpdated && context.mounted) {
          context.read<ProductCubit>().getProductDetails(productId: product.id);
        }
        if (respond == NavigationReturn.productArchived && context.mounted) {
          context.pop(true);
        }
      },
      icon: const Icon(Icons.edit_outlined),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
