import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:shagaf_ledger/core/common/app_consts.dart';
import 'package:shagaf_ledger/core/common/entities/product.dart';
import 'package:shagaf_ledger/core/routes/navigation_return.dart';

class AppNavigator {
  Future<bool?> navToOrderDetailsPage(
    BuildContext context, {
    required int orderId,
  }) async => await context.pushNamed<bool>(
    AppConsts().orderDetails,
    pathParameters: {'orderId': orderId.toString()},
  );

  Future<bool?> navToAddOrderPage(BuildContext context) async =>
      await context.pushNamed(AppConsts().addNewOrderPage);

  Future<bool?> navToArchivedProductsPage(BuildContext context) async =>
      await context.pushNamed(AppConsts().archivedProductsPage);

  Future<bool?> navToAddProductPage(BuildContext context) async =>
      await context.pushNamed(AppConsts().addProductPage);

  Future<bool?> navToInventoryHistoryPage(BuildContext context) =>
      context.pushNamed(AppConsts().inventoryHistoryPage);

  Future<NavigationReturn?> navToEditProductPage(
    BuildContext context, {
    required Product product,
  }) async => await context.pushNamed(
    AppConsts().editProductPage,
    extra: product,
    pathParameters: {"productId": product.id.toString()},
  );

  Future<bool?> navToClientDetailsPage(
    BuildContext context, {
    required int clientId,
  }) => context.pushNamed(
    AppConsts().clientDetailsPage,
    pathParameters: {'clientId': clientId.toString()},
  );

  Future<bool?> navToAddClientPage(BuildContext context) async =>
      await context.pushNamed(AppConsts().addClientPage);

  Future<bool?> navToProductDetailsPage(
    BuildContext context, {
    required int productId,
  }) async => await context.pushNamed(
    AppConsts().productDetailsPage,
    pathParameters: {"productId": productId.toString()},
  );
}
