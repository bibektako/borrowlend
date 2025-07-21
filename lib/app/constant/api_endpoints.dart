class ApiEndpoints {
  ApiEndpoints._();

  //TimeOuts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  //connection with local host
  static const String serverAddress = "http://localhost:5050";

  //static const String serverAddress = "http://10.0.2.2:5050";

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
  static const String items = "items";

  static const String getMyItems = "items/my-items";

  //reviews
  static const String createReview = "reviews/create";
  static const String getReviews = "reviews"; // Used for GET / with query params
  static const String updateReview = "reviews/"; // Append {id} for PUT
  static const String deleteReview = "reviews/"; // Append {id} for DELETE
  static const String getReviewById = "reviews/";


}
