import 'package:flutter/material.dart';
import 'package:shagaf_ledger/features/clients/domain/entities/client_entity.dart';

class ClientTile extends StatelessWidget {
  final ClientEntity client;
  final VoidCallback? onTap;

  const ClientTile({super.key, required this.client, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Text(
            client.name.isNotEmpty ? client.name[0].toUpperCase() : '?',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        title: Text(client.name),
        // subtitle: client.phoneNumber != null
        //     ? Text(client.phoneNumber.toString())
        //     : null,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
