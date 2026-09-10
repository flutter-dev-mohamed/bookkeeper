import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/app_navigator/app_navigator.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/core/common/functions/stock_formatting.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onProductDetailsChange;

  const ProductTile({
    super.key,
    required this.product,
    required this.onProductDetailsChange,
  });

  void _navigateToProductDetailsPage(BuildContext context) async {
    final changed = await AppNavigator().navToProductDetailsPage(
      context,
      productId: product.id,
    );

    if (changed == true && context.mounted) {
      onProductDetailsChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // TODO: change these values
    final bool isLowStock = product.currentInventory <= 200;
    final bool isOutOfStock = product.currentInventory == 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToProductDetailsPage(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Product icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text("📦", style: TextStyle(fontSize: 24)),
                ),
              ),

              const SizedBox(width: 14),

              // Product information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 15,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${stockFormatting(product.currentInventory)} قطعة',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              if (isOutOfStock)
                _InventoryStatus(
                  label: 'Out of stock',
                  color: colorScheme.error,
                )
              else if (isLowStock)
                _InventoryStatus(
                  label: 'Low stock',
                  color: colorScheme.tertiary,
                ),

              const SizedBox(width: 8),

              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _InventoryStatus extends StatelessWidget {
  final String label;
  final Color color;

  const _InventoryStatus({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
