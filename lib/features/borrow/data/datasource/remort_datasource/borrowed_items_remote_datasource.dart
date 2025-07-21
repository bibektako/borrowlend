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
    final data = res.data['data'] as List;
    return data.map((json) => BorrowRequestModel.fromJson(json)).toList();
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
