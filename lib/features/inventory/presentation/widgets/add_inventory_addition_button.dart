import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/inventory_addition.dart';
import 'package:shagaf_ledger/features/inventory/presentation/state/add_inventory_addition_cubit/add_inventory_addition_cubit.dart';
import 'package:shagaf_ledger/features/inventory/presentation/widgets/add_addition_card.dart';

class AddInventoryAdditionButton extends StatefulWidget {
  final int productId;
  final VoidCallback onInventoryAdditionAdded;

  const AddInventoryAdditionButton({
    super.key,
    required this.productId,
    required this.onInventoryAdditionAdded,
  });

  @override
  State<AddInventoryAdditionButton> createState() =>
      _AddInventoryAdditionButtonState();
}

class _AddInventoryAdditionButtonState
    extends State<AddInventoryAdditionButton> {
  @override
  void initState() {
    final InventoryAddition inventoryAddition = InventoryAddition(
      id: 0,
      productId: widget.productId,
      quantity: 0,
      unitPurchasePrice: 0,
      unitSellingPrice: 0,
      createdAt: DateTime.now().toIso8601String().split('T')[0],
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => context.read<AddInventoryAdditionCubit>().updateState(
        inventoryAddition: inventoryAddition,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddInventoryAdditionCubit, AddInventoryAdditionState>(
      listener: (context, state) {
        if (state is AddInventoryAdditionAdded) {
          widget.onInventoryAdditionAdded();
        }
      },
      builder: (context, state) {
        if (state is AddInventoryAdditionLoading) {
          return CustomPrimaryButton(
            text: 'إضافة',
            onPressed: () {},
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return CustomPrimaryButton(
          text: 'إضافة',
          onPressed: () => _showAddAdditionDialog(
            context,
            onUpdateSate: (stock, unitPurchasePrice, unitSellingPrice, note) {
              context.read<AddInventoryAdditionCubit>().updateState(
                inventoryAddition: InventoryAddition(
                  id: 0,
                  productId: widget.productId,
                  quantity: stock,
                  unitPurchasePrice: unitPurchasePrice,
                  unitSellingPrice: unitSellingPrice,
                  createdAt: DateTime.now().toIso8601String().split('T')[0],
                ),
              );
            },
            onAddAddition: () => context
                .read<AddInventoryAdditionCubit>()
                .addInventoryAddition(),
          ),
        );
      },
    );
  }

  void _showAddAdditionDialog(
    BuildContext context, {
    required VoidCallback onAddAddition,
    required void Function(
      int stock,
      double unitPurchasePrice,
      double unitSellingPrice,
      String note,
    )
    onUpdateSate,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            //  ————————————————————————————————————————————————————————————————  title
            title: Text(
              'تسجيل إضافة للمخزون ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            //  ————————————————————————————————————————————————————————————————  content
            content: AddAdditionCard(onUpdateSate: onUpdateSate),
            contentPadding: EdgeInsets.all(8),
            //  ————————————————————————————————————————————————————————————————  actions
            actions: [
              TextButton(
                onPressed: () => context.pop(),

                child: const Text('إلغاء', style: TextStyle(fontSize: 16)),
              ),

              MaterialButton(
                onPressed: () {
                  // pop the dialog
                  context.pop(true);
                  onAddAddition();
                },
                color: Colors.green.shade100,
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(16),
                ),
                child: Text(
                  'إضافة',
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
