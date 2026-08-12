import 'package:animated_segmented_tab_control_plus/animated_segmented_tab_control_plus.dart';
import 'package:flutter/material.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';

enum DiscountType { amount, percentage }

class DiscountInput extends StatefulWidget {
  final DiscountType initialType;
  final double initialValue;

  final void Function({required DiscountType type, required double value})
  onChanged;

  const DiscountInput({
    super.key,
    this.initialType = DiscountType.amount,
    this.initialValue = 0,
    required this.onChanged,
  });

  @override
  State<DiscountInput> createState() => _DiscountInputState();
}

class _DiscountInputState extends State<DiscountInput>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _textController;

  late DiscountType _discountType;

  @override
  void initState() {
    super.initState();

    _discountType = widget.initialType;

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _discountType.index,
    );

    _textController = TextEditingController(
      text: widget.initialValue == 0 ? '' : widget.initialValue.toString(),
    );

    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;

    setState(() {
      _discountType = DiscountType.values[_tabController.index];
    });

    _notifyParent();
  }

  void _onValueChanged(String value) {
    final parsedValue = double.tryParse(value) ?? 0;

    widget.onChanged(type: _discountType, value: parsedValue);
  }

  void _notifyParent() {
    final value = double.tryParse(_textController.text) ?? 0;

    widget.onChanged(type: _discountType, value: value);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPercentage = _discountType == DiscountType.percentage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedTabControl(
          controller: _tabController,

          height: 44,

          barDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),

          indicatorDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),

          tabTextColor: Theme.of(context).colorScheme.onSurfaceVariant,

          selectedTabTextColor: Theme.of(context).colorScheme.onPrimary,

          tabs: const [
            SegmentTab(label: 'مبلغ'),
            SegmentTab(label: 'نسبة'),
          ],
        ),

        const SizedBox(height: 12),

        TextField(
          controller: _textController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: _onValueChanged,
          decoration: InputDecoration(
            hintText: isPercentage ? 'نسبة الخصم' : 'مبلغ الخصم',
            suffixText: isPercentage ? '%' : 'د.ع',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ],
    );
  }
}
