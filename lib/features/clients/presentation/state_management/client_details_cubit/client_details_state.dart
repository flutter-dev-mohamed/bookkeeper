part of 'client_details_cubit.dart';

@immutable
sealed class ClientDetailsState {}

final class ClientDetailsInitial extends ClientDetailsState {}

final class ClientDetailsLoading extends ClientDetailsState {}

final class GotClientDetails extends ClientDetailsState {
  final ClientEntity client;

  GotClientDetails({required this.client});
}

final class ClientDetailsFailure extends ClientDetailsState {
  final String message;

  ClientDetailsFailure({required this.message});
}
