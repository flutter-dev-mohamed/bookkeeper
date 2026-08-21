import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/inventory/presentation/bloc/inventory_bloc.dart';

class ArchiveProductButton extends StatelessWidget {
  final Product product;

  const ArchiveProductButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CustomPrimaryButton(
        text: 'ارشفة المنتج',
        onPressed: () {
          _showCancelDialog(context);
        },
        backgroundColor: Colors.redAccent.shade200,
        foregroundColor: Colors.white,
      ),
    );
  }

  //  ——————————————————————————————————————————————————————————————————————————  Cancel order dialog
  void _showCancelDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
                  context.read<InventoryBloc>().add(
                    ArchiveProductEvent(product: product),
                  );
                  context.pop();
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
