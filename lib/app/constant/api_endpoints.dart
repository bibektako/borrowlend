class ApiEndpoints {
  ApiEndpoints._();

  //TimeOuts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  //connection with local host
  // static const String serverAddress = "http://localhost:5050";

  static const String serverAddress = "http://192.168.2.106:5050";

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
  static const String reviews = "reviews";
  static String updateReview(String reviewId) => "reviews/$reviewId";
  static String deleteReview(String reviewId) => "reviews/$reviewId";

  static String getReviewById(String reviewId) => "reviews/$reviewId";

  //bookings
  static String createBorrowRequest(String itemId) => "borrow/request/$itemId";
  static const String getBorrowRequests = "borrow/requests";
  static const String getOngoingBorrowings = "borrow/ongoing";
  static String updateBorrowRequest(String requestId) =>
      "borrow/request/$requestId";

  static const String getNotifications = "notifications";
}
