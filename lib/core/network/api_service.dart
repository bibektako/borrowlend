import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/app/shared_pref/token_shared_prefs.dart';
import 'package:borrowlend/core/network/auth_interceptor.dart';
import 'package:borrowlend/core/network/dio_error_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  final Dio _dio;


  String? _authToken;

  ApiService(this._dio) {
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      ..interceptors.add(DioErrorInterceptor())
      ..interceptors.add(AuthInterceptor(getToken: () => _authToken))
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      )
      ..options.headers = {
        'Accepts': 'application/json',
        'Content-Type': 'application/json',
      };
  }

  /// Call this when login succeeds or app starts
  void setAuthToken(String token) {
    _authToken = token;
  }
  Future<void> ensureAuthTokenLoaded() async {
    if (_authToken == null) {
      final result = await serviceLocator<TokenSharedPrefs>().getToken();
      result.fold(
        (_) {},
        (token) {
          if (token != null && token.isNotEmpty) {
            _authToken = token;
          }
        },
      );
    }
  }
    Dio get dio => _dio;


}
