import 'package:borrowlend/features/borrow/data/datasource/borrow_remote_data_source.dart';
import 'package:borrowlend/features/borrow/domain/entity/borrow_request_entity.dart';
import 'package:borrowlend/features/borrow/domain/repository/borrowed_item_repository.dart';

class BorrowedItemsRemoteRepository implements BorrowedItemsRepository {
  final IBorrowRemoteDataSource _remoteDataSource;

  BorrowedItemsRemoteRepository(this._remoteDataSource);

  @override
  Future<void> createBorrowRequest(String itemId) {
    return _remoteDataSource.createBorrowRequest(itemId);
  }

  @override
  Future<List<BorrowRequestEntity>> getBorrowRequests() async {
    final models = await _remoteDataSource.getBorrowRequests();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> updateRequestStatus(String requestId, String status) {
    return _remoteDataSource.updateRequestStatus(requestId, status);
  }
}
