import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/features/orders/presentation/orders_bloc/orders_bloc.dart';

class DateFilterWidget extends StatefulWidget {
  const DateFilterWidget({super.key});

  @override
  State<DateFilterWidget> createState() => _DateFilterWidgetState();
}

class _DateFilterWidgetState extends State<DateFilterWidget> {
  Future<void> _selectDate(BuildContext context, DateTime dateFilter) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dateFilter,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      // check if the date didn't change
      if (pickedDate == dateFilter) {
        return;
      }
      OPrint.g(
        'Selected Date: ${pickedDate.toLocal().toString().split(' ')[0]}',
      );
      if (context.mounted) {
        context.read<OrdersBloc>().add(GetOrdersEvent(day: pickedDate));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        final dateFilter = state is OrdersLoaded
            ? state.dateFilter
            : DateTime.now();
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Hero(
            // Use a unique tag if you want this to transition to a full calendar page later
            tag: 'date_filter_hero',
            child: Material(
              type: MaterialType.transparency,
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _selectDate(context, dateFilter),
                borderRadius: BorderRadius.circular(8.0),
                child: Center(
                  child: Text(
                    _formatDateTime(dateFilter),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    overflow: TextOverflow.visible,
                    softWrap: false,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();

    // Strip the time part by creating new DateTime objects using year, month, and day only
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (targetDate == today) {
      return 'Today';
    } else if (targetDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      // Returns the yyyy-mm-dd format
      return dateTime.toIso8601String().split('T')[0];
    }
  }
}
