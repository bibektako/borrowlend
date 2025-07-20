class ApiEndpoints {
  ApiEndpoints._();

  //TimeOuts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  //connection with local host
  static const String serverAddress = "http://localhost:5050";

  static const String baseUrl = "$serverAddress/api/";
  //Auth
  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String getUser = "auth/me";
  static const String bookmarks = "auth/bookmarks";

  //Category
  static const String getAllCategory = "admin/category";

  // items
  static const String getAllItems = "items";
}
