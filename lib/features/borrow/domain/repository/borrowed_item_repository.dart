import 'package:borrowlend/features/borrow/domain/entity/borrow_request_entity.dart';

abstract interface class BorrowedItemsRepository {
  Future<void> createBorrowRequest(String itemId);

  Future<List<BorrowRequestEntity>> getBorrowRequests();

  Future<void> updateRequestStatus(String requestId, String status);
}
