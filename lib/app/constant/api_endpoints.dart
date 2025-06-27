class ApiEndpoints {
  ApiEndpoints._();

  //TimeOuts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  //connection with local host
  static const String serverAddress = "http://10.0.2.2:5050";

  static const String baseUrl = "$serverAddress/api/";
  //Auth
  static const String login = "auth/login";
  static const String register = "auth/register";
}