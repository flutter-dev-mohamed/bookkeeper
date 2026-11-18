sealed class AddOrderEffect {}

final class ShowAddOrderErrorDialog extends AddOrderEffect {
  final String message;

  ShowAddOrderErrorDialog({required this.message});
}
