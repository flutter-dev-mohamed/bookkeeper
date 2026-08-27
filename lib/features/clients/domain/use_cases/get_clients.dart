import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/clients/domain/entities/client_entity.dart';
import 'package:shagaf_ledger/features/clients/domain/repository/clients_repository.dart';

class GetClients implements UseCases<List<ClientEntity>, NoParams> {
  final ClientsRepository _clientsRepository;

  GetClients({required this._clientsRepository});

  @override
  Future<Either<Failure, List<ClientEntity>>> call(NoParams params) async =>
      await _clientsRepository.getClients();
}
