import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/features/inventory/presentation/cubit/product_cubit/product_cubit.dart';

class ArchiveProductButton extends StatelessWidget {
  final int productId;

  ArchiveProductButton({super.key, required this.productId});

  bool thisOne = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        //  this will pop the edite product page
        if (state is ProductArchived) context.pop(true);

        // in case of an error cancel loading
        if (state is ProductFailure) thisOne = false;
      },

      builder: (context, state) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CustomPrimaryButton(
            text: 'ارشفة المنتج',
            onPressed: () {
              thisOne = true;
              _showArchiveProductDialog(context);
            },
            backgroundColor: Colors.redAccent.shade200,
            foregroundColor: Colors.white,
            child: (state is ProductLoading && thisOne)
                //  this will check for loading and if the button is thisOne
                ? CircularProgressIndicator()
                : null,
          ),
        );
      },
    );
  }

  //  ——————————————————————————————————————————————————————————————————————————  archive product dialog
  void _showArchiveProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: colorScheme.surface,
            shadowColor: colorScheme.shadow,
            title: Text(
              'أرشفة المنتج؟',
              style: TextStyle(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text.rich(
              TextSpan(
                text:
                    "سيتم إخفاء هذا المنتج من قائمة المنتجات والمخزون النشط، لكن لن يتم حذفه. يمكنك العثور عليه لاحقًا من",
                children: [
                  TextSpan(
                    text: ' قسم المنتجات المؤرشفة',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextSpan(text: ' وإعادته إلى المنتجات النشطة.'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),

                child: const Text('إلغاء', style: TextStyle(fontSize: 16)),
              ),

              //  ——————————————————————————————————————————————————————————————  cancel order
              MaterialButton(
                onPressed: () {
                  // pop the dialog
                  context.pop();
                  context.read<ProductCubit>().archiveProduct(
                    productId: productId,
                  );
                },
                color: colorScheme.errorContainer,
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(16),
                ),
                child: Text(
                  'أرشفة',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
