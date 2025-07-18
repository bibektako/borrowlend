// lib/core/network/auth_interceptor.dart
import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/app/shared_pref/token_shared_prefs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final nonProtectedRoutes = [
      ApiEndpoints.login,
      ApiEndpoints.register,
    ];

    if (nonProtectedRoutes.contains(options.path)) {
      return handler.next(options);
    }
    
    debugPrint("--- Interceptor running for protected route: [${options.method}] ${options.path} ---");

    final tokenPrefs = serviceLocator<TokenSharedPrefs>();

    final tokenResult = await tokenPrefs.getToken();

    tokenResult.fold(
      // This code runs if getting the token from storage fails
      (failure) {
        debugPrint("❌ Interceptor: FAILED to retrieve token. Error: ${failure.message}");
        // You might want to reject the request if the token can't be read
        // handler.reject(DioException(requestOptions: options, error: failure));
      },
      // This code runs if getting the token from storage succeeds
      (token) {
        if (token != null && token.isNotEmpty) {
          debugPrint("✅ Interceptor: Token found. Attaching to header.");
          // Attach the token to the request's Authorization header
          options.headers['Authorization'] = 'Bearer $token';
        } else {
          debugPrint("⚠️ Interceptor: No token found in storage for protected route.");
        }
      },
    );

    // Continue the request with the (potentially modified) options
    return handler.next(options);
  }
}