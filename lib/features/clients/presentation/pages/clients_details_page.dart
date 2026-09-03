import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/pages/loading_page.dart';
import 'package:shagaf_ledger/features/clients/domain/entities/client_entity.dart';
import 'package:shagaf_ledger/features/clients/presentation/state_management/client_details_cubit/client_details_cubit.dart';
import 'package:shagaf_ledger/features/orders/presentation/widgets/client_orders_card.dart';

class ClientDetailsPage extends StatelessWidget {
  final int clientId;

  const ClientDetailsPage({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    // TODO: ADD FUNCTIONALITY TO THE PHONE, WHATSAPP, ADN INSTAGRAM
    return BlocBuilder<ClientDetailsCubit, ClientDetailsState>(
      builder: (context, state) {
        //  ————————————————————————————————————————————————————————————————————  loading
        if (state is ClientDetailsLoading) return LoadingPage();

        //  ————————————————————————————————————————————————————————————————————  page UI
        if (state is GotClientDetails) {
          final client = state.client;
          final phone = client.phoneNumber;
          final whatsApp = client.whatsApp;
          final instagram = client.instagram;
          final note = client.note;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    client.name,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),

                  if (phone != null && phone.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text('Phone number'),
                      subtitle: Text(phone.toString()),
                    ),
                  ],

                  if (whatsApp != null && whatsApp.isNotEmpty)
                    ListTile(
                      leading: const Icon(Icons.chat),
                      title: const Text('WhatsApp'),
                      subtitle: Text(whatsApp),
                    ),

                  if (instagram != null && instagram.isNotEmpty)
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text('Instagram'),
                      subtitle: Text(instagram),
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

        //  ————————————————————————————————————————————————————————————————————  error
        return ErrorPage();
      },
    );
  }
}
