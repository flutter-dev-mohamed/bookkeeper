import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/core/common/product_list.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/order_item_dropdown_menu.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/quantity_controls.dart';

class SelectedOrderItemTile extends StatefulWidget {
  final OrderItem initialItem;
  final List<Product> availableProducts;
  final int index;
  final void Function({
    required Product oldProduct,
    required Product newProduct,
    required int index,
  })
  onChangedSelection;
  final void Function({required int index, required int quantity})
  onQuantityChanged;
  final void Function(int index) onDelete;

  const SelectedOrderItemTile({
    super.key,
    required this.availableProducts,
    required this.initialItem,
    required this.onChangedSelection,
    required this.index,
    required this.onQuantityChanged,
    required this.onDelete,
  });

  @override
  State<SelectedOrderItemTile> createState() => _SelectedOrderItemTileState();
}

class _SelectedOrderItemTileState extends State<SelectedOrderItemTile> {
  @override
  Widget build(BuildContext context) {
    // the intiItem for this order item
    final initItem = products.firstWhere(
      (product) => product.id == widget.initialItem.productId,
    );
    OPrint.g('build_2 was build');

    // TODO: fix the slidable
    return Slidable(
      key: Key(widget.index.toString()),

      startActionPane: ActionPane(
        motion: const DrawerMotion(),

        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) {
              widget.onDelete(widget.index);
            },
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

                widget.onChangedSelection(
                  oldProduct: initItem,
                  newProduct: newProduct!,
                  index: widget.index,
                );

                // update the quantity
                //
              },
              initialItem: initItem,
              availableProducts: [initItem, ...widget.availableProducts],
            ),
          ),
          QuantityControls(
            maxInventory: initItem.currentInventory,
            quantity: widget.initialItem.quantity,
            index: widget.index,
            onQuantityChanged: widget.onQuantityChanged,
          ),
        ],
      ),
    );
  }
}
