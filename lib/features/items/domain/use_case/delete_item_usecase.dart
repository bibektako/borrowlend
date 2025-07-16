import 'package:borrowlend/app/shared_pref/token_shared_prefs.dart';
import 'package:borrowlend/app/use_case/usecase.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/items/domain/repository/item_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class DeleteItemParams extends Equatable {
  final String id;

  const DeleteItemParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteItemUsecase implements UsecaseWithParams<void, DeleteItemParams> {
  final IItemRepository _itemRepository;
  // Assuming deletion is a protected route and requires a token.
  final TokenSharedPrefs _tokenSharedPrefs; 

  DeleteItemUsecase({
    required IItemRepository itemRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _itemRepository = itemRepository,
        _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call(DeleteItemParams params) async {
    // You might not need to handle the token here if your ApiService
    // automatically adds it to headers. However, following your example:
    final tokenResult = await _tokenSharedPrefs.getToken();
    return tokenResult.fold(
      (failure) => Left(failure),
      // The token itself might not be passed if your API service handles it.
      (token) async => await _itemRepository.deleteItem(params.id),
    );
  }
}