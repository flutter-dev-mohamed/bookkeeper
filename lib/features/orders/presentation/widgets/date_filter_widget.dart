import 'package:flutter/material.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';

class DateFilterWidget extends StatelessWidget {
  const DateFilterWidget({super.key});

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      OPrint.g(
        'Selected Date: ${pickedDate.toLocal().toString().split(' ')[0]}',
      );
      // TODO: Pass this date to your BLoC or state manager to filter your data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Hero(
        // Use a unique tag if you want this to transition to a full calendar page later
        tag: 'date_filter_hero',
        child: Material(
          type: MaterialType.transparency,
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _selectDate(context),
            borderRadius: BorderRadius.circular(8.0),
            child: Center(
              child: Text(
                // 'اليوم',
                '2026-07-23',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                overflow: TextOverflow.visible,
                softWrap: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
