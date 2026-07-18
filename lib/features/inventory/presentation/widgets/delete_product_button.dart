import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/presentation/bloc/inventory_bloc/inventory_bloc.dart';

class DeleteProductButton extends StatelessWidget {
  final Product product;

  const DeleteProductButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CustomPrimaryButton(
        text: 'حذف المنتج',
        onPressed: () {
          OPrint.by('Deleting product...');
          context.read<InventoryBloc>().add(
            DeleteProductEvent(product: product),
          );
          context.pop();
          context.pop();
        },
        backgroundColor: Colors.redAccent.shade200,
        foregroundColor: Colors.white,
      ),
    );
  }
}
