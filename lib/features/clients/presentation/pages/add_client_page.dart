import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/pages/loading_page.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_form_filed.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_primary_button.dart';
import 'package:shagaf_ledger/features/clients/domain/entities/client_entity.dart';
import 'package:shagaf_ledger/features/clients/presentation/state_management/add_client_cubit/add_client_cubit.dart';

class AddClientPage extends StatefulWidget {
  const AddClientPage({super.key});

  @override
  State<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _whatsAppController;
  late final TextEditingController _instagramController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _whatsAppController = TextEditingController();
    _instagramController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _whatsAppController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  void _updateState(BuildContext context) =>
      context.read<AddClientCubit>().updateState(
        client: ClientEntity(
          id: 0,
          name: _nameController.text.trim(),
          createdAt: DateTime.now().toIso8601String().split('T')[0],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<AddClientCubit, AddClientState>(
        listener: (context, state) {
          if (state is ClientAdded) context.pop(true);

          // populate the controllers
          if (state is AddingClient) {
            _nameController.text = state.client.name;
            _phoneNumberController.text = state.client.phoneNumber ?? '';
            _whatsAppController.text = state.client.whatsApp ?? '';
            _instagramController.text = state.client.instagram ?? '';
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'إضافة زيون',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              centerTitle: true,
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(12),
                shrinkWrap: true,
                children: [
                  //
                  CustomFormFiled(
                    controller: _nameController,
                    label: "إسم الزبون",
                    onTapOutside: (_) => _updateState(context),
                    validator: (name) {
                      if (name == null || name.trim().isEmpty) {
                        return 'يرجى إدخال اسم الزبون';
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: 12),
                  CustomFormFiled(
                    //
                    controller: _phoneNumberController,
                    label: 'رقم الهاتف',
                    keyboardType: TextInputType.phone,
                    icon: Icon(Icons.phone_in_talk_rounded),
                    onTapOutside: (p0) => _updateState(context),
                    onFieldSubmitted: (p0) => _updateState(context),
                  ),

                  SizedBox(height: 12),
                  CustomFormFiled(
                    //
                    controller: _whatsAppController,
                    label: "WhatsApp",
                    icon: Image.asset(
                      'lib/core/assets/icons/whatsapp.png',
                      width: 28,
                    ),
                    onTapOutside: (p0) => _updateState(context),
                    onFieldSubmitted: (p0) => _updateState(context),
                  ),

                  SizedBox(height: 12),
                  CustomFormFiled(
                    //
                    controller: _instagramController,
                    label: 'Instagram',
                    icon: Image.asset(
                      'lib/core/assets/icons/instagram.png',
                      width: 28,
                    ),
                    onTapOutside: (p0) => _updateState(context),
                    onFieldSubmitted: (p0) => _updateState(context),
                  ),

                  SizedBox(height: 12),
                  CustomPrimaryButton(
                    text: 'إضافة',
                    child: (state is AddClientLoading)
                        ? SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        : null,
                    onPressed: () {
                      _updateState(context);

                      final isValid =
                          _formKey.currentState?.validate() ?? false;

                      if (isValid) context.read<AddClientCubit>().addClient();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
