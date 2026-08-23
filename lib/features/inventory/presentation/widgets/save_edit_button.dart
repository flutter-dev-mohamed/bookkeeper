import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/presentation/cubit/product_cubit/product_cubit.dart';

class SaveEditButton extends StatelessWidget {
  // this is meant to get the values from the text controllers in the edit product screen
  final Product Function() getProduct;

  SaveEditButton({super.key, required this.getProduct});

  bool thisOne = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        //  this will pop the edite product page
        if (state is ProductUpdated) context.pop(true);

        // in case of an error cancel loading
        if (state is ProductFailure) thisOne = false;
      },

      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: CustomPrimaryButton(
            text: 'حفظ التعديل',
            child: (state is ProductLoading && thisOne)
                //  this will check for loading and if the button is thisOne
                ? CircularProgressIndicator()
                : null,
            onPressed: () {
              thisOne = true;
              context.read<ProductCubit>().updateProduct(product: getProduct());
            },
          ),
        );
      },
    );
  }
}
