import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/clients/domain/entities/client_entity.dart';
import 'package:shagaf_ledger/features/clients/domain/use_cases/get_clients.dart';

part 'clients_state.dart';

class ClientsCubit extends Cubit<ClientsState> {
  final GetClients _getClients;

  ClientsCubit({required this._getClients}) : super(ClientsInitial()) {
    loadClients();
  }

  void loadClients() async {
    emit(ClientsLoading());

    final res = await _getClients(NoParams());

    res.fold(
      (error) => emit(ClientsFailure(message: error.message)),
      (clients) => emit(GotClientsList(clients: clients)),
    );
  }
}
