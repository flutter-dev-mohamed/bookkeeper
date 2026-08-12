import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/core/common/product_list.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';

class OrderItemDropdownMenu extends StatelessWidget {
  final Function(Product?) onChanged;
  final Product? initialItem;
  List<Product> availableProducts;

  OrderItemDropdownMenu({
    super.key,
    required this.onChanged,
    required this.availableProducts,
    this.initialItem,
  });

  @override
  Widget build(BuildContext context) {
    if (availableProducts.isEmpty) {
      return const SizedBox.shrink();
    }
    return CustomDropdown<Product>.search(
      initialItem: initialItem,
      hintText: 'إضافة منتج',
      items: availableProducts,
      onChanged: onChanged,
      // Controls how the selected item looks in the closed box
      headerBuilder: (context, selectedItem, enabled) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // product name
            Text(
              selectedItem.name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),

            // product unit price
            Text(
              selectedItem.sellingPrice.toString(),
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ],
        );
      },
      // Controls how each item looks inside the expanded list/search view
      listItemBuilder: (context, product, isSelected, onItemSelect) {
        return Text(
          product.name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      },
      closedHeaderPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: CustomDropdownDecoration(
        closedFillColor: Theme.of(context).colorScheme.secondaryContainer,
        expandedFillColor: Theme.of(context).colorScheme.secondaryContainer,
        closedBorder: Border.all(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        closedBorderRadius: BorderRadius.circular(16),
        expandedBorderRadius: BorderRadius.circular(16),
        prefixIcon: Image.asset(
          'lib/core/assets/icons/select_product.png',
          width: 30,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
        // closedSuffixIcon: Text(''),
      ),
    );
  }
}
