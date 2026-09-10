import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_text_field.dart';

class Discount extends StatefulWidget {
  const Discount({super.key});

  @override
  State<Discount> createState() => _DiscountState();
}

class _DiscountState extends State<Discount> {
  bool _isDiscount = false;
  bool _isPercenntage = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // check box
          Row(
            children: [
              Checkbox(
                value: _isDiscount,
                onChanged: (value) {
                  setState(() {
                    _isDiscount = !_isDiscount;
                  });
                },
                shape: CircleBorder(),
                side: BorderSide(width: 1),
              ),

              Text('تخفيض'),
            ],
          ),

          // discount field
          if (_isDiscount) _discountTypeSelector(context),
        ],
      ),
    );
  }

  // the discount container UI
  String _selectedDiscountType = 'amount';

  Widget _discountTypeSelector(BuildContext context) {
    return Container(
      //
      color: Theme.of(context).colorScheme.secondaryContainer,
      padding: EdgeInsets.all(16),
      child: Column(
        spacing: 12,
        children: [
          // CupertinoSegmentedControl<String>(
          //   children: const {
          //     'amount': SizedBox(
          //       width: double.infinity,
          //       child: Padding(
          //         padding: EdgeInsets.symmetric(vertical: 12),
          //         child: Text('مبلغ (\$)'),
          //       ),
          //     ),
          //     'percentage': Padding(
          //       padding: EdgeInsets.symmetric(vertical: 12),
          //       child: Text('نسبة (%)'),
          //     ),
          //   },
          //   groupValue: 'amount',
          //   onValueChanged: (String value) {
          //     setState(() {
          //       _selectedDiscountType = _DiscountType.percentage;
          //     });
          //   },
          // ),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'amount', label: Text('مبلغ (\$)')),
              ButtonSegment(value: 'percentage', label: Text('نسبة (%)')),
            ],
            selected: {_selectedDiscountType},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _selectedDiscountType = newSelection.first;
              });
            },
          ),
          // discount amount
          CustomTextField(
            //
            hintText: "قيمة الخصم",
            isDense: true,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
