import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
import 'package:shagaf_ledger/features/orders/presentation/add_order_cubit/add_order_cubit.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/order_item_dropdown_menu.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/quantity_controls.dart';

class SelectedOrderItemTile extends StatelessWidget {
  final OrderItem initialItem;
  final List<Product> availableProducts;
  final int index;
  final Product initProduct;

  const SelectedOrderItemTile({
    super.key,
    required this.availableProducts,
    required this.initialItem,
    required this.index,
    required this.initProduct,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: fix the slidable
    return Slidable(
      key: Key(index.toString()),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,

        children: [
          SlidableAction(
            onPressed: (_) =>
                context.read<AddOrderCubit>().deleteOrderItem(index),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            icon: Icons.delete_rounded,
            label: 'حذف',
            borderRadius: BorderRadius.circular(16),
            autoClose: true,
          ),
        ],
      ),

      child: Row(
        children: [
          Expanded(
            child: OrderItemDropdownMenu(
              onChanged: (newProduct) {
                OPrint.by(
                  'you have changed the selected item to: ${newProduct?.name}',
                );
                if (newProduct != null) {
                  context.read<AddOrderCubit>().changeSelectedProduct(
                    index: index,
                    newProduct: newProduct,
                  );
                }
              },
              initialItem: initProduct,
              availableProducts: [initProduct, ...availableProducts],
            ),
          ),

          QuantityControls(
            maxInventory: initProduct.currentInventory,
            quantity: initialItem.quantity,
            index: index,
            onQuantityChanged: ({required index, required quantity}) => context
                .read<AddOrderCubit>()
                .changeQuantity(index: index, quantity: quantity),
          ),
        ],
      ),
    );
  }
}
