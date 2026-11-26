sealed class ExpensesEffect {}

final class ShowExpensesErrorDialog extends ExpensesEffect {
  final String message;

  ShowExpensesErrorDialog({required this.message});
}
