import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/app_navigator/app_navigator.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/pages/loading_page.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_app_bar.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_fab.dart';
import 'package:shagaf_ledger/features/clients/presentation/pages/clients_details_page.dart';
import 'package:shagaf_ledger/features/clients/presentation/state_management/clients_cubit/clients_cubit.dart';
import 'package:shagaf_ledger/features/clients/presentation/widgets/client_tile.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<ClientsCubit, ClientsState>(
          builder: (context, state) {
            //  ————————————————————————————————————————————————————————————————  loading
            if (state is ClientsLoading) return LoadingPage();

            //  ————————————————————————————————————————————————————————————————  page UI
            if (state is GotClientsList) {
              final clients = state.clients;

              return Scaffold(
                appBar: CustomAppBar(
                  title: const Text(
                    'العملاء',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                ),

                body: clients.isEmpty
                    ? const Center(child: Text('No clients found'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: clients.length,
                        itemBuilder: (context, index) {
                          final client = clients[index];

                          return ClientTile(
                            client: client,
                            onTap: () {
                              // Navigate to the client details page.
                              AppNavigator().navToClientDetailsPage(
                                context,
                                clientId: client.id,
                              );
                            },
                          );
                        },
                      ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.miniStartFloat,
                floatingActionButton: Padding(
                  padding: const EdgeInsets.only(bottom: 110.0),
                  child: CustomFab(
                    onPressed: () async {
                      final didChange = await AppNavigator().navToAddClientPage(
                        context,
                      );

                      if (didChange == true && context.mounted) {
                        context.read<ClientsCubit>().loadClients();
                      }
                    },
                    child: Image.asset(
                      'lib/core/assets/icons/add_client.png',
                      color: Theme.of(context).colorScheme.primary,
                      width: 30,
                    ),
                  ),
                ),
              );
            }

            //  ————————————————————————————————————————————————————————————————  error
            return ErrorPage();
          },
        ),
      ),
    );
  }
}
