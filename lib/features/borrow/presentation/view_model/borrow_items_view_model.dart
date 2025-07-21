import 'package:borrowlend/features/borrow/domain/usecase/create_borrow_request.dart';
import 'package:borrowlend/features/borrow/domain/usecase/get_borrow_request.dart';
import 'package:borrowlend/features/borrow/domain/usecase/update_borrow_request.dart';
import 'package:borrowlend/features/borrow/presentation/view_model/borrow_items_event.dart';
import 'package:borrowlend/features/borrow/presentation/view_model/borrow_items_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BorrowedItemsBloc extends Bloc<BorrowRequestsEvent, BorrowedItemsState> {
  final GetBorrowRequestsUseCase getRequests;
  final UpdateBorrowRequestStatusUseCase updateStatus;
  final CreateBorrowRequestUseCase createRequest;

  BorrowedItemsBloc({
    required this.getRequests,
    required this.updateStatus,
    required this.createRequest,
  }) : super(BorrowedItemsInitial()) {
    on<FetchBorrowRequests>(_onLoadBorrowedItems);
    on<UpdateBorrowRequestStatus>(_onUpdateBorrowRequestStatus);
    on<CreateBorrowRequest>(_onCreateBorrowRequest);
  }

  Future<void> _onLoadBorrowedItems(
    FetchBorrowRequests event,
    Emitter<BorrowedItemsState> emit,
  ) async {
    emit(BorrowedItemsLoading());
    final result = await getRequests();

    result.fold(
      (failure) => emit(BorrowedItemsError(failure.message)),
      (data) => emit(BorrowedItemsLoaded(data)),
    );
  }

  Future<void> _onUpdateBorrowRequestStatus(
    UpdateBorrowRequestStatus event,
    Emitter<BorrowedItemsState> emit,
  ) async {
    emit(BorrowedItemsLoading());
final result = await updateStatus(
    UpdateBorrowRequestStatusParams(
      requestId: event.requestId,
      status: event.status,
    ),
  );
    result.fold(
      (failure) => emit(BorrowedItemsError(failure.message)),
      (_) => add(FetchBorrowRequests()),
    );
  }

  Future<void> _onCreateBorrowRequest(
    CreateBorrowRequest event,
    Emitter<BorrowedItemsState> emit,
  ) async {
    emit(BorrowedItemsLoading());
    final result = await createRequest(event.itemId);

    result.fold(
      (failure) => emit(BorrowedItemsError(failure.message)),
      (_) => add(FetchBorrowRequests()),
    );
  }
}
