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
  final TokenSharedPrefs _tokenSharedPrefs; 

  DeleteItemUsecase({
    required IItemRepository itemRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _itemRepository = itemRepository,
        _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call(DeleteItemParams params) async {
    final tokenResult = await _tokenSharedPrefs.getToken();
    return tokenResult.fold(
      (failure) => Left(failure),
      (token) async => await _itemRepository.deleteItem(params.id),
    );
  }
}