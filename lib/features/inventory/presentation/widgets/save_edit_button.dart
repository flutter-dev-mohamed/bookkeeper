import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/presentation/bloc/inventory_bloc.dart';

class SaveEditButton extends StatelessWidget {
  // this is meant to get the values from the text controllers in the edit product screen
  final Product Function() getProduct;

  const SaveEditButton({super.key, required this.getProduct});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomPrimaryButton(
        text: 'حفظ التعديل',
        onPressed: () {
          context.read<InventoryBloc>().add(
            UpdateProductEvent(product: getProduct()),
          );
        },
      ),
    );
  }
}
