import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthInterceptor extends Interceptor {
  final String? Function() getToken;

  AuthInterceptor({required this.getToken});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final nonProtectedRoutes = [
      ApiEndpoints.login,
      ApiEndpoints.register,
    ];

    if (nonProtectedRoutes.any((route) => options.path.contains(route))) {
      debugPrint("🔓 Public route: ${options.path}");
      return handler.next(options);
    }

    final token = getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      debugPrint("✅ Interceptor attached token: $token");
    } else {
      debugPrint("⚠️ No token found during request to protected route.");
    }

    return handler.next(options);
  }
}
