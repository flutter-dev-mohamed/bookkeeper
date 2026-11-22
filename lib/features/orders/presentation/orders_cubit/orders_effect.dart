sealed class OrdersEffect {}

final class ShowOrdersErrorDialog extends OrdersEffect {
  final String message;

  ShowOrdersErrorDialog({required this.message});
}
