import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/clients/domain/entities/client_entity.dart';
import 'package:shagaf_ledger/features/clients/domain/repository/clients_repository.dart';

class AddClient implements UseCases<void, ClientEntity> {
  final ClientsRepository _clientsRepository;

  AddClient({required this._clientsRepository});

  @override
  Future<Either<Failure, void>> call(ClientEntity client) async =>
      await _clientsRepository.addClient(client: client);
}
