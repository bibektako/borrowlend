import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:borrowlend/core/network/api_service.dart';
import 'package:borrowlend/features/borrow/data/datasource/borrow_remote_data_source.dart';
import 'package:borrowlend/features/borrow/data/model/borrow_request_model.dart';

import 'package:dio/dio.dart';

class BorrowedItemsRemoteDataSource implements IBorrowRemoteDataSource {
  final ApiService _apiService;

  BorrowedItemsRemoteDataSource(this._apiService);

  @override
  Future<void> createBorrowRequest(String itemId) async {
    await _apiService.ensureAuthTokenLoaded();
    await _apiService.dio.post(ApiEndpoints.createBorrowRequest(itemId));
  }

  @override
  Future<List<BorrowRequestModel>> getBorrowRequests() async {
    await _apiService.ensureAuthTokenLoaded();
    final res = await _apiService.dio.get(ApiEndpoints.getBorrowRequests);
    final responseData = res.data['data'];

    if (responseData == null || responseData is! List) {
      return [];
    }
    
    final sanitizedList = responseData.where((json) {
      if (json is! Map<String, dynamic>) return false;

      final bool isValid = json['item'] != null &&
                           json['borrower'] != null &&
                           json['owner'] != null;

      if (!isValid) {
        print('Warning: Skipping corrupt or incomplete record from API: $json');
      }
      
      return isValid;
    }).toList();

    // Now, map the CLEAN and SANITIZED list. This will no longer crash because
    // every item is guaranteed to have the required fields.
    return sanitizedList
        .map((json) => BorrowRequestModel.fromJson(json as Map<String, dynamic>))
        .toList();
    // final data = res.data['data'] as List;
    // return data.map((json) => BorrowRequestModel.fromJson(json)).toList();
  }

  @override
  Future<void> updateRequestStatus(String requestId, String status) async {
    await _apiService.ensureAuthTokenLoaded();
    await _apiService.dio.patch(
      ApiEndpoints.updateBorrowRequest(requestId),
      data: {'status': status},
    );
  }
}
