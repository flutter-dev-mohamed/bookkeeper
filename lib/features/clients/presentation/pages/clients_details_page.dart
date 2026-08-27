import 'package:flutter/material.dart';
import 'package:shagaf_ledger/features/clients/domain/entities/client_entity.dart';

class ClientDetailsPage extends StatelessWidget {
  final ClientEntity client;

  const ClientDetailsPage({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(client.name, style: Theme.of(context).textTheme.headlineLarge),

            if (client.phoneNumber != null) ...[
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Phone number'),
                subtitle: Text(client.phoneNumber.toString()),
              ),
            ],

            if (client.whatsApp != null)
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('WhatsApp'),
                subtitle: Text(client.whatsApp!),
              ),

            if (client.instagram != null)
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Instagram'),
                subtitle: Text(client.instagram!),
              ),

            const SizedBox(height: 24),

            // ClientProductsWidget(
            //   productIds: client.interestProductIds,
            // ),

            // ClientOrdersWidget(
            //   orderIds: client.orderIds,
            // ),
          ],
        ),
      ),
    );
  }
}
