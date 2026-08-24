import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/presentation/cubit/edit_product_cubit/edit_product_cubit.dart';

class SaveEditButton extends StatelessWidget {
  const SaveEditButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProductCubit, EditProductState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          //  this will check for loading and if the button is thisOne
          child: (state is EditingProduct && state.isSubmitting)
              ? CustomPrimaryButton(
                  text: 'حفظ التعديل',
                  onPressed: null,
                  child: CircularProgressIndicator(),
                )
              : CustomPrimaryButton(
                  text: 'حفظ التعديل',
                  onPressed: () {
                    context.read<EditProductCubit>().saveUpdatedProduct();
                  },
                ),
        );
      },
    );
  }
}
