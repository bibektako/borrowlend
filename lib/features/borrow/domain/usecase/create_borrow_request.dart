import 'package:borrowlend/app/use_case/usecase.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/borrow/domain/repository/borrowed_item_repository.dart';
import 'package:dartz/dartz.dart';

class CreateBorrowRequestUseCase implements UsecaseWithParams<void, String> {
  final BorrowedItemsRepository repository;

  CreateBorrowRequestUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String itemId) async {
    try {
      await repository.createBorrowRequest(itemId);
      return right(null);
    } catch (e) {
      return left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
