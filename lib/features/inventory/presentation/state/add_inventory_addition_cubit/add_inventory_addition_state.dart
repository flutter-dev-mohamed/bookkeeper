part of 'add_inventory_addition_cubit.dart';

@immutable
sealed class AddInventoryAdditionState {}

final class AddInventoryAdditionInitial extends AddInventoryAdditionState {}

final class AddingInventoryAddition extends AddInventoryAdditionState {
  final InventoryAddition inventoryAddition;
  final bool hasError;
  final String errorMessage;

  AddingInventoryAddition({
    required this.inventoryAddition,
    this.hasError = false,
    this.errorMessage = '',
  });
}

final class AddInventoryAdditionLoading extends AddInventoryAdditionState {}

final class AddInventoryAdditionAdded extends AddInventoryAdditionState {}
