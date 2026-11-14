sealed class OrderDetailsEffect {}

final class ShowOrderDetailsErrorDialog extends OrderDetailsEffect {
  final String message;

  ShowOrderDetailsErrorDialog({required this.message});
}
