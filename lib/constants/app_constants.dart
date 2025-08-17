class AppConstants {
  // Base URL
  static const String baseUrl = "http://192.168.1.101:8000/";
  static const String loginEndpoint = 'api/method/ledgerctrl.ledgerctrl.api.login_api.user_logn';
  static const String updateUserInfoEndpoint ="/api/method/ledgerctrl.ledgerctrl.api.login_api.update_user_info";
  static const String fecthUserInfoEndpoint ="/api/method/ledgerctrl.ledgerctrl.api.login_api.get_user_info";
  static const String fecthAssignedOrders ="/api/method/ledgerctrl.ledgerctrl.api.trips_api.get_assigned_orders";


  static const String closeDeliveryNote = "api/method/ledgerctrl.api.delivery_note_api.close_delivery_note_with_otp";

  // Auth
  static const String apiKey = "YOUR-KEY";
  static const String apiSecret = "YOUR-SECRET";

  // Headers
  static Map<String, String> get headers => {
    "Authorization": "token $apiKey:$apiSecret",
    "Content-Type": "application/json",
  };
}
