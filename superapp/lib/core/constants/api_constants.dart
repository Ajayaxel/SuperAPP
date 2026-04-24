class ApiConstants {
  static const String baseUrl = "https://electro-backend-electro-backend.up.railway.app";
  
  // Auth Endpoints
  static const String register = "$baseUrl/api/register";
  static const String login = "$baseUrl/api/login";
  static const String profile = "/api/user";
  static const String updateProfile = "/api/user/update";

  // Marketplace
  static const String usedCarCreateData = "/api/used-car-listings/create-data";
  static const String usedCarStore = "/api/used-car-listings";
  
  // Add other endpoints as needed
}
