import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/features/clients/domain/entities/client_entity.dart';
import 'package:shagaf_ledger/features/clients/domain/use_cases/get_client_details.dart';

part 'client_details_state.dart';

class ClientDetailsCubit extends Cubit<ClientDetailsState> {
  final int clientId;
  final GetClientDetails _getClientDetails;

  ClientDetailsCubit({required this.clientId, required this._getClientDetails})
    : super(ClientDetailsInitial()) {
    getClientDetails(clientId: clientId);
  }

  void getClientDetails({required int clientId}) async {
    // emit loading
    emit(ClientDetailsLoading());

    // get the details
    final res = await _getClientDetails(clientId);

    // unfold
    res.fold(
      (error) => emit(ClientDetailsFailure(message: error.message)),
      (client) => emit(GotClientDetails(client: client)),
    );
  }
}
