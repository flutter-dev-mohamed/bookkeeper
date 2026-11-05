import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/core/routes/navigation_return.dart';
import 'package:shagaf_ledger/core/routes/app_page_names.dart';
import 'package:shagaf_ledger/features/inventory/domain/entities/inventory_addition.dart';

class AppNavigator {
  AppNavigator._internal();

  static final AppNavigator _instance = AppNavigator._internal();

  factory AppNavigator() => _instance;

  Future<bool?> navToOrderDetailsPage(
    BuildContext context, {
    required int orderId,
  }) async => await context.pushNamed<bool>(
    AppPageNames.orderDetails,
    pathParameters: {'orderId': orderId.toString()},
  );

  Future<bool?> navToAddOrderPage(BuildContext context) async =>
      await context.pushNamed(AppPageNames.addNewOrderPage);

  Future<bool?> navToArchivedProductsPage(BuildContext context) async =>
      await context.pushNamed(AppPageNames.archivedProductsPage);

  Future<bool?> navToAddProductPage(BuildContext context) async =>
      await context.pushNamed(AppPageNames.addProductPage);

  Future<bool?> navToInventoryHistoryPage(BuildContext context) =>
      context.pushNamed(AppPageNames.inventoryHistoryPage);

  Future<NavigationReturn?> navToEditProductPage(
    BuildContext context, {
    required Product product,
  }) async => await context.pushNamed(
    AppPageNames.editProductPage,
    extra: product,
    pathParameters: {"productId": product.id.toString()},
  );

  Future<bool?> navToClientDetailsPage(
    BuildContext context, {
    required int clientId,
  }) => context.pushNamed(
    AppPageNames.clientDetailsPage,
    pathParameters: {'clientId': clientId.toString()},
  );

  Future<bool?> navToAddClientPage(BuildContext context) async =>
      await context.pushNamed(AppPageNames.addClientPage);

  Future<bool?> navToProductDetailsPage(
    BuildContext context, {
    required int productId,
  }) async => await context.pushNamed(
    AppPageNames.productDetailsPage,
    pathParameters: {"productId": productId.toString()},
  );

  Future<bool?> navToInventoryAdditionDetailsPage(
    BuildContext context, {
    required InventoryAddition addition,
  }) => context.pushNamed(
    AppPageNames.inventoryAdditionDetailsPage,
    extra: addition,
  );
}
