import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/features/clients/domain/entities/client_entity.dart';
import 'package:shagaf_ledger/features/clients/domain/use_cases/add_client.dart';

part 'add_client_state.dart';

class AddClientCubit extends Cubit<AddClientState> {
  final AddClient _addClient;

  AddClientCubit({required this._addClient}) : super(AddClientInitial()) {
    emit(
      AddingClient(
        client: ClientEntity(id: 0, name: ' ', createdAt: ''),
      ),
    );
  }

  void addClient() async {
    final currentState = state;
    if (currentState is! AddingClient) return;

    emit(AddClientLoading());

    final res = await _addClient(currentState.client);

    res.fold(
      (error) => emit(
        AddingClient(client: currentState.client, errorMessage: error.message),
      ),
      (_) => emit(ClientAdded()),
    );
  }

  void updateState({required ClientEntity client}) =>
      emit(AddingClient(client: client));
}
