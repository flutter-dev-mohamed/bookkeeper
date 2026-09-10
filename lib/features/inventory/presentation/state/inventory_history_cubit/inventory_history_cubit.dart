import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/inventory_addition.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/get_inventory_additions.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/get_product_additions.dart';

part 'inventory_history_state.dart';

class InventoryHistoryCubit extends Cubit<InventoryHistoryState> {
  final GetInventoryAdditions _getInventoryAdditions;
  final GetProductAdditions _getProductAdditions;

  InventoryHistoryCubit({
    required this._getInventoryAdditions,
    required this._getProductAdditions,
  }) : super(InventoryHistoryInitial());

  void getInventoryAdditions() async {
    OPrint.lineG('getInventoryAdditions: Fetching inventory history...');
    emit(InventoryHistoryLoading());

    final res = await _getInventoryAdditions(NoParams());

    res.fold(
      (error) {
        OPrint.lineR('getInventoryAdditions Error: ${error.message}');
        emit(InventoryHistoryFailure(message: error.message));
      },
      (additions) {
        OPrint.lineG(
          'getInventoryAdditions Success: Loaded ${additions.length} additions',
        );
        emit(
          InventoryHistoryGotAdditions(additions: additions.reversed.toList()),
        );
      },
    );
  }

  void getProductAdditions({required int productId}) async {
    emit(InventoryHistoryLoading());

    final res = await _getProductAdditions(productId);

    res.fold(
      (error) => emit(InventoryHistoryFailure(message: error.message)),
      (additions) => emit(
        InventoryHistoryGotAdditions(additions: additions.reversed.toList()),
      ),
    );
  }
}
