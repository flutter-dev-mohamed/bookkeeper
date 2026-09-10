import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/functions/try_repo.dart';
import 'package:shagaf_ledger/features/clients/data/database/clients_database.dart';
import 'package:shagaf_ledger/features/clients/data/models/client_entity_model.dart';
import 'package:shagaf_ledger/features/clients/domain/entities/client_entity.dart';
import 'package:shagaf_ledger/features/clients/domain/repository/clients_repository.dart';
import 'package:sqflite/sqflite.dart';

class ClientsRepositoryImp implements ClientsRepository {
  final ClientsDatabase _clientsDatabase;
  final Database _database;

  ClientsRepositoryImp({
    required this._clientsDatabase,
    required this._database,
  });

  @override
  Future<Either<Failure, List<ClientEntity>>> getClients() async =>
      tryRepo<List<ClientEntity>>(() async {
        final clientMapsList = await _clientsDatabase.getClients();

        final clientsList = clientMapsList.map((clientMap) {
          return ClientModel.fromMap(clientMap);
        }).toList();

        return clientsList;
      });

  @override
  Future<Either<Failure, void>> addClient({
    required ClientEntity client,
  }) async => tryRepo<void>(() async {
    final clientMap = ClientModel.fromEntity(client).toMap();

    return await _database.transaction(
      (txn) => _clientsDatabase.addClient(executor: txn, clientMap: clientMap),
    );
  });

  @override
  Future<Either<Failure, ClientEntity>> getClientDetails({
    required int clientId,
  }) async => await tryRepo<ClientModel>(() async {
    final clientMap = await _clientsDatabase.getClientDetails(
      clientId: clientId,
    );

    final client = ClientModel.fromMap(clientMap);

    return client;
  });
}
