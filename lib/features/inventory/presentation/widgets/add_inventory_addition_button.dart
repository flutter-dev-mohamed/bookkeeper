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
  final _formKey = GlobalKey<FormState>();

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
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final cubit = context.read<AddInventoryAdditionCubit>();

        return CustomPrimaryButton(
          text: 'إضافة',
          onPressed: () => showDialog(
            context: context,
            builder: (dialogContext) {
              return BlocProvider.value(
                value: cubit,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    title: const Text(
                      'تسجيل إضافة للمخزون ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: AddAdditionCard(
                      productId: widget.productId,
                      formKey: _formKey,
                    ),
                    contentPadding: const EdgeInsets.all(8),
                    actions: [
                      TextButton(
                        onPressed: () => dialogContext.pop(),
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      // Use a Builder here to get a context under the BlocProvider.value
                      Builder(
                        builder: (buttonContext) {
                          return MaterialButton(
                            onPressed: () {
                              final bool isValid =
                                  _formKey.currentState?.validate() ?? false;

                              if (!isValid) return;

                              buttonContext
                                  .read<AddInventoryAdditionCubit>()
                                  .addInventoryAddition();
                              buttonContext.pop();
                            },
                            color: Colors.green.shade100,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'إضافة',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
