import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/app_consts.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/products/presentation/cubit/product_cubit/product_cubit.dart';

class EditButton extends StatelessWidget {
  final Product product;

  const EditButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () async {
          final didChange = await context.pushNamed(
            AppConsts().editProductPage,
            extra: product,
            pathParameters: {"productId": product.id.toString()},
          );

          if (didChange == true && context.mounted) {
            context.read<ProductCubit>().getProductDetails(
              productId: product.id,
              didChange: true,
            );
          }
        },
        icon: const Icon(Icons.edit_outlined),
        label: const Text('تعديل المنتج'),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
