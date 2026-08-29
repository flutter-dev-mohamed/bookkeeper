import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/inventory_addition.dart';
import 'package:shagaf_ledger/features/inventory/domain/use_cases/add_inventory_addition.dart';

part 'add_inventory_addition_state.dart';

class AddInventoryAdditionCubit extends Cubit<AddInventoryAdditionState> {
  // add_inventory_addition
  final AddInventoryAddition _addInventoryAddition;

  AddInventoryAdditionCubit({required this._addInventoryAddition})
    : super(AddInventoryAdditionInitial());

  void addInventoryAddition() async {
    OPrint.lineG(
      'addInventoryAddition: Attempting to add inventory addition...',
    );
    final currentState = state;

    if (currentState is! AddingInventoryAddition) {
      OPrint.lineY(
        'addInventoryAddition Aborted: Current state is not AddingInventoryAddition (found ${currentState.runtimeType})',
      );
      return;
    }

    if (currentState.hasError) {
      OPrint.lineY(
        'addInventoryAddition Aborted: Current state has an unresolved error.',
      );
      return;
    }

    OPrint.lineG('addInventoryAddition: Emitting loading state...');
    emit(AddInventoryAdditionLoading());

    final inventoryAddition = currentState.inventoryAddition;
    OPrint.c(
      'inventoryAddition -> id: ${inventoryAddition.id}, productId: ${inventoryAddition.productId}, quantity: ${inventoryAddition.quantity}, totalPrice: ${inventoryAddition.totalPrice}, addedCost: ${inventoryAddition.addedCost}',
    );

    final res = await _addInventoryAddition(currentState.inventoryAddition);

    await Future.delayed(Duration(milliseconds: 500));

    res.fold(
      (error) {
        OPrint.lineR('addInventoryAddition Error: ${error.message}');
        emit(
          AddingInventoryAddition(
            inventoryAddition: currentState.inventoryAddition,
            hasError: true,
            errorMessage: error.message,
          ),
        );
      },
      (_) {
        OPrint.lineG(
          'addInventoryAddition Success: Inventory addition added successfully.',
        );
        emit(AddInventoryAdditionAdded());
      },
    );
  }

  void updateState({
    required InventoryAddition inventoryAddition,
    bool hasError = false,
  }) {
    OPrint.lineC('updateState (AddingInventoryAddition)');
    OPrint.c('hasError: $hasError');
    OPrint.c(
      'inventoryAddition -> id: ${inventoryAddition.id}, productId: ${inventoryAddition.productId}, quantity: ${inventoryAddition.quantity}, totalPrice: ${inventoryAddition.totalPrice}, addedCost: ${inventoryAddition.addedCost}',
    );

    emit(
      AddingInventoryAddition(
        inventoryAddition: inventoryAddition,
        hasError: hasError,
      ),
    );
  }
}
