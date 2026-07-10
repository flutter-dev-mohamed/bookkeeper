import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/app_consts.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/presentation/bloc/inventory_bloc.dart';

class EditProductButton extends StatelessWidget {
  final Product product;

  const EditProductButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomPrimaryButton(
        text: "تعديل المنتج",
        onPressed: () {
          context.read<InventoryBloc>().add(EditProductEvent(product: product));
        },
      ),
    );
  }
}
