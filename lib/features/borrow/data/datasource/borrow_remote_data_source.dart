import 'package:borrowlend/features/borrow/data/model/borrow_request_model.dart';

abstract class IBorrowRemoteDataSource {
  Future<void> createBorrowRequest(String itemId);
  Future<List<BorrowRequestModel>> getBorrowRequests();
  Future<void> updateRequestStatus(String requestId, String status);
}
