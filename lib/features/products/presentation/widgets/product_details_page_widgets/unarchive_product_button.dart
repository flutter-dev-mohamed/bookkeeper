import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/features/products/presentation/cubit/product_cubit/product_cubit.dart';

class UnarchiveProductButton extends StatelessWidget {
  final int productId;

  const UnarchiveProductButton({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    // TODO: take a look at the archive product button
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: (state is GotProductDetails && state.isSubmitting)
              ? CustomPrimaryButton(
                  text: 'تفعيل المنتج',
                  onPressed: null,
                  child: CircularProgressIndicator(),
                )
              : CustomPrimaryButton(
                  text: 'تفعيل المنتج',

                  onPressed: () => _showUnarchiveProductDialog(
                    context,
                    unarchiveProduct: () =>
                        context.read<ProductCubit>().removeProductFromArchive(),
                  ),
                ),
        );
      },
    );
  }

  //  ——————————————————————————————————————————————————————————————————————————  unarchive product dialog
  void _showUnarchiveProductDialog(
    BuildContext context, {
    required VoidCallback unarchiveProduct,
  }) {
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
              'إلغاء أرشفة المنتج؟',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),

            content: const Text(
              'سيتم إرجاع هذا المنتج إلى قائمة المنتجات النشطة، '
              'وسيظهر مجددًا في المخزون ويمكن استخدامه عند إنشاء الطلبات.',
            ),

            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('إلغاء', style: TextStyle(fontSize: 16)),
              ),

              MaterialButton(
                onPressed: () {
                  // pop the dialog
                  context.pop();
                  unarchiveProduct();
                },
                color: colorScheme.secondaryContainer,
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Text(
                  'إلغاء الأرشفة',
                  style: TextStyle(fontSize: 16, color: colorScheme.primary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
