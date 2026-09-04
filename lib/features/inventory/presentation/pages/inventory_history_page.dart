import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/pages/loading_page.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_app_bar.dart';
import 'package:shagaf_ledger/features/inventory/presentation/state/inventory_history_cubit/inventory_history_cubit.dart';
import 'package:shagaf_ledger/features/inventory/presentation/widgets/inventory_addition_tile.dart';

class InventoryHistoryPage extends StatefulWidget {
  const InventoryHistoryPage({super.key});

  @override
  State<InventoryHistoryPage> createState() => _InventoryHistoryPageState();
}

class _InventoryHistoryPageState extends State<InventoryHistoryPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) =>
          context.read<InventoryHistoryCubit>().getInventoryAdditions(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<InventoryHistoryCubit, InventoryHistoryState>(
        builder: (context, state) {
          if (state is InventoryHistoryLoading) return LoadingPage();
          if (state is InventoryHistoryGotAdditions) {
            final additions = state.additions;

            return Scaffold(
              appBar: CustomAppBar(
                title: Text(
                  'السجل',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
              ),
              body: ListView.builder(
                shrinkWrap: true,
                itemCount: additions.length,
                itemBuilder: (context, index) {
                  final addition = additions[index];
                  return InventoryAdditionTile(addition: addition);
                },
              ),
            );
          }

          return ErrorPage();
        },
      ),
    );
  }
}
