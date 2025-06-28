import 'dart:convert';

import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:borrowlend/core/network/api_service.dart';
import 'package:borrowlend/features/auth/data/data_source/user_data_source.dart';
import 'package:borrowlend/features/auth/data/model/user_api_model.dart';
import 'package:borrowlend/features/auth/domain/entity/user_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class UserRemoteDatasource implements IUserDataSource {
  final ApiService _apiService;
  UserRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<void> createUser(UserEntity user) async {
    try {
      final userAPiModel = UserApiModel.fromEntity(user);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userAPiModel.toJson(),
      );
      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception('Failed to register user: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to register user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to register student: $e');
    }
  }

  @override
  Future<void> deleteUser(String userId) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<String> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      debugPrint(response.data);

      if (response.statusCode == 200 && response.data != null) {
        // Dio should parse JSON automatically, but we add checks for safety.
        // 1. Ensure the response data is a Map (a JSON object).
        if (response.data is! Map<String, dynamic>) {
          throw Exception('Invalid response format. Expected a JSON object.');
        }
        final Map<String, dynamic> responseData = response.data;

        // 2. Check if the 'token' key exists and is the correct type (String).
        if (responseData.containsKey('token') &&
            responseData['token'] is String) {
          final String token = responseData['token'];
          return token;
        } else {
          // This will throw a more specific error if the token is missing or not a string.
          throw Exception(
            'Login successful, but the "token" is missing or not a String.',
          );
        }
      } else {
        // Handle non-200 status codes or null data.
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      // Re-throw Dio specific errors for more clarity in logs.
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      // Catch our own exceptions or any other parsing errors.
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
