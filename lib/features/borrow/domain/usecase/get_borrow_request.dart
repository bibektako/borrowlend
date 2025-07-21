import 'package:borrowlend/app/use_case/usecase.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/borrow/domain/entity/borrow_request_entity.dart';
import 'package:borrowlend/features/borrow/domain/repository/borrowed_item_repository.dart';
import 'package:dartz/dartz.dart';

class GetBorrowRequestsUseCase implements UsecaseWithoutParams<List<BorrowRequestEntity>> {
  final BorrowedItemsRepository repository;

  GetBorrowRequestsUseCase(this.repository);

  @override
  Future<Either<Failure, List<BorrowRequestEntity>>> call() async {
    try {
      final requests = await repository.getBorrowRequests();
      return right(requests);
    } catch (e) {
      return left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
