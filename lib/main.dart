import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shagaf_ledger/core/assets/theme/lib/theme.dart';
import 'package:shagaf_ledger/core/assets/theme/lib/util.dart';
import 'package:shagaf_ledger/core/routes/app_routes.dart';
import 'package:shagaf_ledger/features/inventory/presentation/bloc/inventory_bloc/inventory_bloc.dart';
import 'package:shagaf_ledger/features/inventory/presentation/pages/inventory_page.dart';
import 'package:shagaf_ledger/initDependencies/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<InventoryBloc>()),
      ],
      child: const ShagafLedger(),
    ),
  );
}

class ShagafLedger extends StatelessWidget {
  const ShagafLedger({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(
      context,
      "JetBrains Mono",
      "JetBrains Mono",
    );
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: AppRoutes().goRouter,
    );
  }
}
