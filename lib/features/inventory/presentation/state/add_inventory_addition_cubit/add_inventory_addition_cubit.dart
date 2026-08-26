import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/inventory_addition.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/add_inventory_addition.dart';

part 'add_inventory_addition_state.dart';

class AddInventoryAdditionCubit extends Cubit<AddInventoryAdditionState> {
  // add_inventory_addition
  final AddInventoryAddition _addInventoryAddition;

  AddInventoryAdditionCubit({required this._addInventoryAddition})
    : super(AddInventoryAdditionInitial());

  void updateState({required InventoryAddition inventoryAddition}) =>
      emit(AddingInventoryAddition(inventoryAddition: inventoryAddition));

  void addInventoryAddition() async {
    final currentState = state;
    if (currentState is! AddingInventoryAddition) return;

    emit(AddInventoryAdditionLoading());

    final res = await _addInventoryAddition(currentState.inventoryAddition);

    res.fold(
      (error) => emit(
        AddingInventoryAddition(
          inventoryAddition: currentState.inventoryAddition,
          hasError: true,
          errorMessage: error.message,
        ),
      ),
      (_) => emit(AddInventoryAdditionAdded()),
    );
  }
}
