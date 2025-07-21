import 'package:equatable/equatable.dart';
import '../../domain/entity/borrow_request_entity.dart';

abstract class BorrowedItemsState extends Equatable {
  const BorrowedItemsState();

  @override
  List<Object?> get props => [];
}

class BorrowedItemsInitial extends BorrowedItemsState {}

class BorrowedItemsLoading extends BorrowedItemsState {}

class BorrowedItemsLoaded extends BorrowedItemsState {
  final List<BorrowRequestEntity> _requests;

  const BorrowedItemsLoaded(this._requests);

  List<BorrowRequestEntity> get requests => _requests;

  @override
  List<Object?> get props => [_requests];
}

class BorrowedItemsError extends BorrowedItemsState {
  final String message;

  const BorrowedItemsError(this.message);

  @override
  List<Object?> get props => [message];
}
