import 'package:borrowlend/features/category/domain/use_case/get_all_category_usecase.dart';
import 'package:borrowlend/features/category/presentation/view_model/category_event.dart';
import 'package:borrowlend/features/category/presentation/view_model/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategoryUsecase _getAllCategoryUsecase;

  CategoryBloc({required GetAllCategoryUsecase getAllCategoryUsecase})
      : _getAllCategoryUsecase = getAllCategoryUsecase,
        super(CategoryInitial()) {
    on<FetchCategories>(_onFetchCategories);
  }

  Future<void> _onFetchCategories(
    FetchCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    final result = await _getAllCategoryUsecase();
    result.fold(
      (failure) => emit(CategoryFailure(errorMessage: failure.message)),
      (categories) => emit(CategorySuccess(categories: categories)),
    );
  }
}