import 'package:equatable/equatable.dart';

abstract class BorrowRequestsEvent extends Equatable {
  const BorrowRequestsEvent();

  @override
  List<Object?> get props => [];
}

class FetchBorrowRequests extends BorrowRequestsEvent {}

class CreateBorrowRequest extends BorrowRequestsEvent {
  final String itemId;

  const CreateBorrowRequest(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class UpdateBorrowRequestStatus extends BorrowRequestsEvent {
  final String requestId;
  final String status;

  const UpdateBorrowRequestStatus(
     this.requestId,
     this.status,
  );

  @override
  List<Object?> get props => [requestId, status];
}
