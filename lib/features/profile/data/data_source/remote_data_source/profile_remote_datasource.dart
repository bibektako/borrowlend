import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:borrowlend/core/network/api_service.dart';
import 'package:borrowlend/features/profile/data/model/user_profile_api_model.dart';
import 'package:dio/dio.dart';

class ProfileRemoteDataSource {
  final ApiService _apiService;

  ProfileRemoteDataSource(this._apiService);

  Future<UserProfileModel> getProfile() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.login);

      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load profile',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to get profile: ${e.message}');
    }
  }

  /// Sends updated user profile data to the API.
  ///
  // /// Takes a [UserProfileModel] and serializes it to JSON for the request body.
  // Future<void> updateProfile(UserProfileModel profile) async {
  //   try {
  //     // Example: PUT /api/v1/users/:id
  //     // The API endpoint might vary, e.g., it might just be '/users'
  //     // and the server identifies the user from the auth token.
  //     final response = await _apiService.dio.put(
  //       '${ApiEndpoints.updateProfile}/${profile.id}',
  //       data: profile.toJson(),
  //     );

  //     if (response.statusCode != 200) {
  //        throw DioException(
  //         requestOptions: response.requestOptions,
  //         response: response,
  //         error: 'Failed to update profile',
  //       );
  //     }
  //   } on DioException catch (e) {
  //     throw Exception('Failed to update profile: ${e.message}');
  //   }
  // }
}