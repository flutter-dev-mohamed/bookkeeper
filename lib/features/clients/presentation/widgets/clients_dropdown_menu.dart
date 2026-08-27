import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shagaf_ledger/features/clients/domain/entities/client_entity.dart';
import 'package:shagaf_ledger/features/clients/presentation/state_management/clients_cubit/clients_cubit.dart';

class ClientsDropdownMenu extends StatelessWidget {
  final void Function(int) onSelectClient;

  const ClientsDropdownMenu({super.key, required this.onSelectClient});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientsCubit, ClientsState>(
      builder: (context, state) {
        if (state is GotClientsList) {
          final clientsList = state.clients;

          return CustomDropdown<ClientEntity>.search(
            //
            items: clientsList,
            hintText: 'إضافة عميل',
            onChanged: (client) {
              if (client == null) return;
              onSelectClient(client.id);
            },

            headerBuilder: (context, selectedClient, enabled) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // product name
                  Text(
                    selectedClient.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },

            listItemBuilder: (context, client, isSelected, onItemSelect) {
              return Text(
                client.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            },

            closedHeaderPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: CustomDropdownDecoration(
              closedFillColor: Theme.of(context).colorScheme.surfaceContainer,
              expandedFillColor: Theme.of(context).colorScheme.surfaceContainer,
              closedBorder: Border.all(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              closedBorderRadius: BorderRadius.circular(16),
              expandedBorderRadius: BorderRadius.circular(16),
              prefixIcon: Image.asset(
                'lib/core/assets/icons/public_relation.png',
                width: 28,
              ),
            ),
          );
        }

        // error
        return SizedBox(
          height: 30,
          child: Center(
            child: Image.asset('lib/core/assets/icons/error.png', width: 25),
          ),
        );
      },
    );
  }
}
