import 'package:flutter/material.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/features/clients/domain/entities/client_entity.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/client_orders_card.dart';

class ClientDetailsPage extends StatelessWidget {
  final ClientEntity client;

  const ClientDetailsPage({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final phone = client.phoneNumber;
    final whatsApp = client.whatsApp;
    final instagram = client.instagram;
    final note = client.note;

    OPrint.lineBy('ClientDetailsPage: \nclient phone: ${client.phoneNumber}');

    // TODO: ADD FUNCTIONALITY TO THE PHONE, WHATSAPP, ADN INSTAGRAM
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(client.name, style: Theme.of(context).textTheme.headlineLarge),

            if (phone != null && phone.isNotEmpty) ...[
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Phone number'),
                subtitle: Text(client.phoneNumber.toString()),
              ),
            ],

            if (whatsApp != null && whatsApp.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('WhatsApp'),
                subtitle: Text(client.whatsApp!),
              ),

            if (instagram != null && instagram.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Instagram'),
                subtitle: Text(client.instagram!),
              ),

            if (note != null && note.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.sticky_note_2_rounded),
                title: Text(note),
                // title: const Text('ملاحظة'),
                // subtitle: Text(note),
              ),

            const SizedBox(height: 24),

            // ClientProductsWidget(
            //   productIds: client.interestProductIds,
            // ),
            ClientOrdersCard(),
          ],
        ),
      ),
    );
  }
}
