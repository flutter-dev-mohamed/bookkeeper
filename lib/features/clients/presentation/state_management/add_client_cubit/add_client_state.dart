part of 'add_client_cubit.dart';

@immutable
sealed class AddClientState {}

final class AddClientInitial extends AddClientState {}

final class AddClientLoading extends AddClientState {}

final class AddingClient extends AddClientState {
  final ClientEntity client;
  final String? errorMessage;

  AddingClient({required this.client, this.errorMessage});
}

final class ClientAdded extends AddClientState {}

// final class AddClient extends AddClientState {}
