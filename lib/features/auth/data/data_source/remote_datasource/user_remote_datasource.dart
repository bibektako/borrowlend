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
      if (response.statusCode != 201) {
        throw Exception('Failed to register user: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to register user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      debugPrint("Attempting to log in user: $email");
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      debugPrint("Received response with statusCode: ${response.statusCode}");

      if (response.statusCode == 200 && response.data != null) {
        // --- ADDED FOR DEBUGGING ---
        debugPrint("Response data type is: ${response.data.runtimeType}");
        debugPrint("Full response data: ${response.data.toString()}");
        // -------------------------

        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData = jsonDecode(response.data);
        } else {
          responseData = response.data;
        }

        if (responseData.containsKey('token') &&
            responseData['token'] is String) {
          final String token = responseData['token'];
          // --- ADDED FOR DEBUGGING ---
          debugPrint("Successfully extracted token: $token");
          // -------------------------
          return token;
        } else {
          throw Exception(
            'Login successful, but the "token" is missing or not a String.',
          );
        }
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      debugPrint("DioException caught: ${e.message}");
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      // This will catch our own exceptions from above.
      debugPrint("Generic exception caught: ${e.toString()}");
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // --- Unimplemented Methods ---
  @override
  Future<void> deleteUser(String userId) {
    throw UnimplementedError();
  }

  @override
  Future<String> getCurrentUser() {
    throw UnimplementedError();
  }
}
