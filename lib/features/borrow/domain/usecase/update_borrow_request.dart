import 'package:borrowlend/app/use_case/usecase.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/borrow/domain/repository/borrowed_item_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdateBorrowRequestStatusParams extends Equatable {
  final String requestId;
  final String status;

  const UpdateBorrowRequestStatusParams({
    required this.requestId,
    required this.status,
  });

  @override
  List<Object?> get props => [requestId, status];
}

class UpdateBorrowRequestStatusUseCase
    implements UsecaseWithParams<void, UpdateBorrowRequestStatusParams> {
  final BorrowedItemsRepository repository;

  UpdateBorrowRequestStatusUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateBorrowRequestStatusParams params) async {
    try {
      await repository.updateRequestStatus(params.requestId, params.status);
      return right(null);
    } catch (e) {
      return left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
