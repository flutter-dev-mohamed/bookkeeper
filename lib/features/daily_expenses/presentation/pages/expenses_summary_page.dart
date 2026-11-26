import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shagaf_ledger/core/app_navigator/app_navigator.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/functions/price_formate.dart';
import 'package:shagaf_ledger/core/common/icons/app_icons.dart';
import 'package:shagaf_ledger/core/common/pages/loading_page.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_app_bar.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_fab.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/entities/expense.dart';
import 'package:shagaf_ledger/features/daily_expenses/presentation/state_management/expenses/expenses_cubit.dart';
import 'dart:math' as math;

class ExpensesSummaryPage extends StatelessWidget {
  const ExpensesSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<ExpensesCubit, ExpensesState>(
      builder: (context, state) {
        if (state is ExpensesLoading) {
          return const LoadingPage();
        }

        if (state is ExpensesLoaded) {
          final marketingTotal = state.totalAmountFor(ExpenseType.marketing);
          final transportTotal = state.totalAmountFor(ExpenseType.transport);
          final rentTotal = state.totalAmountFor(ExpenseType.rent);
          final otherTotal = state.totalAmountFor(ExpenseType.other);
          final grandTotal = state.totalAllExpenses;

          final colors = [
            colorScheme.primary,
            colorScheme.secondary,
            colorScheme.tertiary,
            colorScheme.error,
          ];

          return Scaffold(
            appBar: CustomAppBar(
              title: Text(
                'Expenses',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                onPressed: () => AppNavigator().navToExpensesPage(context),
                icon: Image.asset(AppIcons.expensesListFiled, width: 30),
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              children: [
                // 1. Hero overview chart
                _ExpensesOverviewBarCard(
                  grandTotal: grandTotal,
                  totals: [
                    marketingTotal,
                    transportTotal,
                    rentTotal,
                    otherTotal,
                  ],
                  colors: colors,
                ),
                const SizedBox(height: 16),

                // 2. Category breakdown cards
                _ExpenseCategoryCard(
                  title: 'Marketing',
                  icon: Icons.campaign_outlined,
                  accentColor: colors[0],
                  items: state.marketingExpenses,
                  categoryTotal: marketingTotal,
                  grandTotal: grandTotal,
                ),
                const SizedBox(height: 12),
                _ExpenseCategoryCard(
                  title: 'Transport',
                  icon: Icons.local_shipping_outlined,
                  accentColor: colors[1],
                  items: state.transportExpenses,
                  categoryTotal: transportTotal,
                  grandTotal: grandTotal,
                ),
                const SizedBox(height: 12),
                _ExpenseCategoryCard(
                  title: 'Rent',
                  icon: Icons.store_outlined,
                  accentColor: colors[2],
                  items: state.rentExpenses,
                  categoryTotal: rentTotal,
                  grandTotal: grandTotal,
                ),
                const SizedBox(height: 12),
                _ExpenseCategoryCard(
                  title: 'Other',
                  icon: Icons.receipt_long_outlined,
                  accentColor: colors[3],
                  items: state.otherExpenses,
                  categoryTotal: otherTotal,
                  grandTotal: grandTotal,
                ),
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: CustomFab(
                onPressed: () => AppNavigator().navToAddExpenseSheet(context),
                child: Image.asset(
                  AppIcons.expensesOutlined,
                  width: 30,
                  color: colorScheme.primary,
                ),
              ),
            ),
          );
        }

        return const ErrorPage();
      },
    );
  }
}

class _ExpensesOverviewBarCard extends StatelessWidget {
  const _ExpensesOverviewBarCard({
    required this.grandTotal,
    required this.totals,
    required this.colors,
  });

  final double grandTotal;
  final List<double> totals;
  final List<Color> colors;

  /// Used for the left side of the overview card
  String formatCompact(double value) {
    if (value.isNaN || value.isInfinite) return value.toString();

    int num = value.ceil();
    bool isNegative = num < 0;
    int absNum = num.abs();

    if (absNum < 1000) return num.toString();

    const suffixes = ['', 'k', 'M', 'B', 'T'];
    int tier = (math.log(absNum) / math.ln10 / 3).floor();
    if (tier >= suffixes.length) tier = suffixes.length - 1;

    double scaled = absNum / math.pow(10, tier * 3);
    String formatted = scaled % 1 == 0
        ? scaled.toStringAsFixed(0)
        : scaled.toStringAsFixed(1);

    if (formatted == '1000' && tier + 1 < suffixes.length) {
      formatted = '1';
      tier++;
    }

    return '${isNegative ? '-' : ''}$formatted${suffixes[tier]}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final maxRaw = totals.fold(0.0, (a, b) => a > b ? a : b);
    final maxY = maxRaw > 0 ? maxRaw * 1.25 : 10.0;
    const labels = ['Marketing', 'Transport', 'Rent', 'Other'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Overview',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  priceFormate(grandTotal),
                  // grandTotal.toStringAsFixed(2),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 170,
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        getTitlesWidget: (value, meta) {
                          if (value == 0 || value == meta.max) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            formatCompact(value),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, _) {
                          final i = value.toInt();
                          if (i < 0 || i >= labels.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              labels[i],
                              style: theme.textTheme.labelSmall,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    for (var i = 0; i < totals.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: totals[i],
                            color: colors[i],
                            width: 24,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseCategoryCard extends StatelessWidget {
  const _ExpenseCategoryCard({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.items,
    required this.categoryTotal,
    required this.grandTotal,
  });

  final String title;
  final IconData icon;
  final Color accentColor;
  final List<Expense> items;
  final double categoryTotal;
  final double grandTotal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ratio = grandTotal > 0 ? (categoryTotal / grandTotal) : 0.0;
    final percent = ratio * 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: accentColor.withValues(alpha: 0.14),
                  child: Icon(icon, size: 20, color: accentColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${items.length} ${items.length == 1 ? 'entry' : 'entries'}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      priceFormate(categoryTotal),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${percent.toStringAsFixed(1)}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio.clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
