import 'package:borrowlend/app/use_case/usecase.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/items/domain/repository/bookmark_repository.dart';
import 'package:dartz/dartz.dart';

class AddBookmarkUseCase implements UsecaseWithParams<void, String> {
  final IBookmarkRepository _repository;
  AddBookmarkUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(String params) => _repository.addBookmark(params);
}