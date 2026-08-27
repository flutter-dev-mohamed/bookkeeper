part of 'clients_cubit.dart';

@immutable
sealed class ClientsState {}

final class ClientsInitial extends ClientsState {}

final class ClientsLoading extends ClientsState {}

final class ClientsFailure extends ClientsState {
  final String message;

  ClientsFailure({required this.message});
}

final class GotClientsList extends ClientsState {
  final List<ClientEntity> clients;

  GotClientsList({required this.clients});
}

// final class Clients extends ClientsState {}
