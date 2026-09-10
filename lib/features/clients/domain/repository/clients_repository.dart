import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/features/clients/domain/entities/client_entity.dart';

abstract interface class ClientsRepository {
  Future<Either<Failure, List<ClientEntity>>> getClients();

  Future<Either<Failure, void>> addClient({required ClientEntity client});

  Future<Either<Failure, ClientEntity>> getClientDetails({
    required int clientId,
  });
}
