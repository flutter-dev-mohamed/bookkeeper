import 'package:flutter/material.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_text_field.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/discount_input.dart';

class OrderSummarySheet extends StatefulWidget {
  final void Function({
    required String noteText,
    required DiscountType discountType,
    required double discountValue,
  })
  onContinue;
  final List<OrderItem> orderItems;
  final bool isLoading;

  const OrderSummarySheet({
    super.key,
    required this.onContinue,
    required this.orderItems,
    required this.isLoading,
  });

  @override
  State<OrderSummarySheet> createState() => _OrderSummarySheetState();
}

class _OrderSummarySheetState extends State<OrderSummarySheet> {
  late final TextEditingController _noteController;
  DiscountType _discountType = DiscountType.amount;
  double _discountValue = 0;

  @override
  void initState() {
    _noteController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _calculateTotal({bool addDiscount = true}) {
    double total = 0;
    for (final orderItem in widget.orderItems) {
      double itemTotal = orderItem.unitSellingPrice * orderItem.quantity;
      total += itemTotal;
    }

    // count for the discount
    if (_discountValue > 0 && addDiscount) {
      total = _calculateDiscount(total);
    }

    return total.toString();
  }

  double _calculateDiscount(double total) {
    if (_discountType == DiscountType.amount) {
      final result = total - _discountValue;
      return result;
    } else {
      final discountedAmount = (total / 100) * _discountValue;
      final result = total - discountedAmount;

      return result;
    }
  }

  @override
  Widget build(BuildContext context) {
    //  ────────────────────────────────────────────────────────────────────────  this is so that when use empties the orderItems list and this shouldn't show you don't loss user input for: note and discount
    if (widget.orderItems.isEmpty) {
      return const SizedBox.shrink();
    }

    //  ────────────────────────────────────────────────────────────────────────  Page UI
    return DraggableScrollableSheet(
      initialChildSize: 0.13,
      minChildSize: 0.13,
      maxChildSize: 0.85,
      snap: true,
      snapSizes: const [0.13, 0.85],

      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                spreadRadius: 2,
                color: Colors.black.withValues(alpha: 0.15),
              ),
            ],
          ),

          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              // Grab handle
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              //  ──────────────────────────────────────────────────────────────  total and action button
              Row(
                children: [
                  // total price
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            //
                            text: _calculateTotal(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          TextSpan(text: " "),

                          if (_discountValue > 0)
                            TextSpan(
                              text: _calculateTotal(addDiscount: false),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Action button
                  Material(
                    color: !widget.isLoading
                        ? Theme.of(context).colorScheme.primary
                        : null,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => widget.onContinue(
                        discountType: _discountType,
                        discountValue: _discountValue,
                        noteText: _noteController.text.trim(),
                      ),
                      child: SizedBox(
                        width: 52,
                        height: 52,
                        child: widget.isLoading
                            ? CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.primary,
                                strokeWidth: 2,
                              )
                            : const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'خصم',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),
              //  ──────────────────────────────────────────────────────────────  discount
              DiscountInput(
                onChanged: ({required type, required value}) => setState(() {
                  _discountType = type;
                  _discountValue = value;
                }),
              ),

              const SizedBox(height: 10),
              //  ──────────────────────────────────────────────────────────────  note
              CustomTextField(
                controller: _noteController,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                unfocusOnTapOutSide: true,
                hint: Text(
                  'ملاحظة',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
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
