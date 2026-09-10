import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/clients/domain/entities/client_entity.dart';
import 'package:shagaf_ledger/features/clients/domain/repository/clients_repository.dart';

class GetClientDetails implements UseCases<ClientEntity, int> {
  final ClientsRepository _clientsRepository;

  GetClientDetails({required this._clientsRepository});

  @override
  Future<Either<Failure, ClientEntity>> call(int clientId) async =>
      _clientsRepository.getClientDetails(clientId: clientId);
}
