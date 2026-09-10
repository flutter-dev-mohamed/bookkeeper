class ClientEntity {
  final int id;
  final String name;
  final String? phoneNumber;
  final String? whatsApp;
  final String? instagram;
  final String? note;
  final String createdAt;

  ClientEntity({
    required this.id,
    required this.name,
    required this.createdAt,
    this.phoneNumber,
    this.whatsApp,
    this.instagram,
    this.note,
  });
}
