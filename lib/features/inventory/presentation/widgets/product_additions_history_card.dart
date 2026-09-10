import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/functions/date_formatting.dart';
import 'package:shagaf_ledger/core/common/functions/price_formate.dart';
import 'package:shagaf_ledger/core/common/functions/stock_formatting.dart';
import 'package:shagaf_ledger/features/inventory/presentation/state/inventory_history_cubit/inventory_history_cubit.dart';

class ProductAdditionsHistoryCard extends StatefulWidget {
  final int productId;

  const ProductAdditionsHistoryCard({super.key, required this.productId});

  @override
  State<ProductAdditionsHistoryCard> createState() =>
      _ProductAdditionsHistoryCardState();
}

class _ProductAdditionsHistoryCardState
    extends State<ProductAdditionsHistoryCard> {
  void loadAdditions() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => context.read<InventoryHistoryCubit>().getProductAdditions(
        productId: widget.productId,
      ),
    );
  }

  @override
  void initState() {
    loadAdditions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إضافات المخزون',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            _additionsList(),
          ],
        ),
      ),
    );
  }

  Widget _additionsList() {
    return BlocBuilder<InventoryHistoryCubit, InventoryHistoryState>(
      builder: (context, state) {
        final colors = Theme.of(context).colorScheme;

        // —————————————————————————————————————————————————————————————————————  indicate loading
        if (state is InventoryHistoryLoading) {
          return CircularProgressIndicator();
        }

        // —————————————————————————————————————————————————————————————————————  additions list
        if (state is InventoryHistoryGotAdditions) {
          final inventoryAdditions = state.additions;

          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 500),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: inventoryAdditions.length,
              itemBuilder: (context, index) {
                final addition = inventoryAdditions[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 0,
                  color: colors.secondaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.add_box_outlined, color: colors.primary),

                            const SizedBox(width: 10),

                            Text(
                              '+${stockFormatting(addition.quantity)} قطعة',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colors.onSecondaryContainer,
                              ),
                            ),

                            const Spacer(),

                            Text(
                              addition.createdAt,
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.onSecondaryContainer,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfoItem(
                              context,
                              title: 'سعر الشراء',
                              value: addition.unitPurchasePrice,
                            ),
                            _buildInfoItem(
                              context,
                              title: 'سعر البيع',
                              value: addition.unitSellingPrice,
                            ),
                          ],
                        ),

                        _buildInfoItem(
                          context,
                          title: 'الكلفة المضافة',
                          value: addition.addedCost,
                        ),
                        _buildInfoItem(
                          context,
                          title: 'التكلفة الكلية',
                          value: addition.totalPrice,
                        ),

                        if (addition.note.isNotEmpty) ...[
                          const SizedBox(height: 12),

                          Divider(
                            color: colors.onSecondaryContainer.withValues(
                              alpha: 0.2,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            addition.note,
                            style: TextStyle(
                              fontSize: 13,
                              color: colors.onSecondaryContainer,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        // —————————————————————————————————————————————————————————————————————  error
        return Center(
          child: Image.asset('lib/core/assets/icons/error.png', width: 80),
        );
      },
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required String title,
    required double value,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12, color: colors.onSecondaryContainer),
        ),

        const SizedBox(height: 4),

        Text(
          priceFormate(value),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: colors.onSecondaryContainer,
          ),
        ),
      ],
    );
  }
}
