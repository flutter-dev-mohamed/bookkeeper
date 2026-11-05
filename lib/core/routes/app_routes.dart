//************************************************************************//
//************************************************************************//
//************************************************************************//
/// This class is used in the app router and is NOT TO BE USED ANYWHERE ELSE
class AppRoutes {
  AppRoutes._();

  // Shell / Bottom Nav Routes (Parent routes)
  static const String ordersPage = '/orders';
  static const String productsPage = '/products';
  static const String clientsPage = '/clients';

  // --- Clients Nested Routes ---
  /// Nested route for the clients page HAS A clientId PARAM
  static const String clientDetails = ':clientId';

  /// Nested route for the clients page
  static const String addClient = 'add_client_page';

  // --- Products & Inventory Nested Routes ---
  /// Nested route for the products page
  static const String addProduct = 'add_product';

  /// Nested route for the products page HAS productId AS PARAM
  static const String productDetails = ':productId';

  /// Nested route for the productDetails page
  static const String editProduct = 'edit_product';

  /// Nested route for the products page
  static const String archivedProducts = 'archived_products';

  /// Nested route for the products page
  static const String inventoryHistory = 'inventoryHistory';

  /// Nested route for the inventoryHistory page
  static const String inventoryAdditionDetails = 'inventory_addition_details';

  // --- Orders Nested Routes ---
  /// Nested route for the orders page
  static const String addNewOrder = '$ordersPage/addNewOrder';

  /// Nested route for the orders page HAS orderId AS PARAM
  static const String orderDetails = ':orderId';
}
