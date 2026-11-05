class AppPageNames {
  AppPageNames._();

  // products
  static const String ordersPage = "ordersPage";
  static const String productsPage = "productsPage";
  static const String productDetailsPage = "productDetailsPage";
  static const String editProductPage = "editProductPage";
  static const String addProductPage = "addProductPage";
  static const String archivedProductsPage = "archivedProductsPage";

  // inventory history
  static const String inventoryHistoryPage = "inventoryHistoryPage";

  /// This page requires `InventoryAddition` to be passed as extra
  static const String inventoryAdditionDetailsPage =
      "inventoryAdditionDetailsPage";

  // orders
  static const String addNewOrderPage = "addNewOrderPage";
  static const String orderDetails = "orderDetails";

  // clients

  static const String clientsPage = 'clientsPage';

  /// This path need: clientId in the params
  static const String clientDetailsPage = 'clientDetailsPage';
  static const String addClientPage = 'addClientPage';
}
