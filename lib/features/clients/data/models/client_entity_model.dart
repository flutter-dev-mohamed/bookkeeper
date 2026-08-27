import 'dart:convert';
import '../../domain/entities/client_entity.dart';

class ClientModel extends ClientEntity {
  ClientModel({
    required super.id,
    required super.name,
    required super.createdAt,
    super.phoneNumber,
    super.whatsApp,
    super.instagram,
    super.note,
  });

  /// Creates a [ClientModel] from a Map (e.g., SQLite database or JSON response).
  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'] is int ? map['id'] : int.parse(map['id'].toString()),
      name: map['name'] ?? '',
      phoneNumber: map['phone_number'],
      whatsApp: map['whatsApp'],
      instagram: map['instagram'],
      createdAt: map['created_at'],
      note: map['note'],
    );
  }

  /// Converts the [ClientModel] into a Map for local database insertion or serialization.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone_number': phoneNumber,
      'whatsApp': whatsApp,
      'instagram': instagram,
      'created_at': createdAt,
      'note': note,
    };
  }

  /// Creates a [ClientModel] from an existing Domain [ClientEntity].
  factory ClientModel.fromEntity(ClientEntity entity) {
    return ClientModel(
      id: entity.id,
      name: entity.name,
      phoneNumber: entity.phoneNumber,
      whatsApp: entity.whatsApp,
      instagram: entity.instagram,
      createdAt: entity.createdAt,
      note: entity.note,
    );
  }

  @override
  String toString() {
    return 'ClientModel('
        'id: $id, '
        'name: $name, '
        'phoneNumber: $phoneNumber, '
        'whatsApp: $whatsApp, '
        'instagram: $instagram, '
        'note: $note, '
        ')';
  }
}
