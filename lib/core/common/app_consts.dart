import 'package:shagaf_ledger/features/clients/domain/entities/client_entity.dart';

class AppConsts {
  // products
  final String ordersPage = "ordersPage";
  final String productsPage = "productsPage";
  final String productDetailsPage = "productDetailsPage";
  final String editProductPage = "editProductPage";
  final String addProductPage = "addProductPage";
  final String archivedProductsPage = "archivedProductsPage";

  // inventory history
  final String inventoryHistoryPage = "inventoryHistoryPage";

  /// This page requires `InventoryAddition` to be passed as extra
  final String inventoryAdditionDetailsPage = "inventoryAdditionDetailsPage";

  // orders
  final String addNewOrderPage = "addNewOrderPage";
  final String orderDetails = "orderDetails";

  // clients

  final String clientsPage = 'clientsPage';

  /// This path need: clientId in the params
  final String clientDetailsPage = 'clientDetailsPage';
  final String addClientPage = 'addClientPage';
}
