part of 'inventory_history_cubit.dart';

@immutable
sealed class InventoryHistoryState {}

final class InventoryHistoryInitial extends InventoryHistoryState {}

final class InventoryHistoryLoading extends InventoryHistoryState {}

final class InventoryHistoryFailure extends InventoryHistoryState {
  final String message;

  InventoryHistoryFailure({required this.message});
}

final class InventoryHistoryGotAdditions extends InventoryHistoryState {
  final List<InventoryAddition> additions;

  InventoryHistoryGotAdditions({required this.additions});
}
