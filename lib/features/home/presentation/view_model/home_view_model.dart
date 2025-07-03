import 'dart:ffi';

import 'package:borrowlend/features/home/data/dto/get_all_category_dto.dart';
import 'package:borrowlend/features/home/domain/use_case/get_all_category_usecase.dart';
import 'package:borrowlend/features/home/presentation/view_model/home_event.dart';
import 'package:borrowlend/features/home/presentation/view_model/home_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewModel extends Bloc<HomeEvent, HomeState>{
  final GetAllCategoryUsecase getAllCategoryUsecase;

  HomeViewModel({
    required this.getAllCategoryUsecase,
  }): super( HomeState.initial()) { on<LoadCategoryEvent>(_onLoadCategory);

    add(LoadCategoryEvent());
  }



Future<void> _onLoadCategory(
  LoadCategoryEvent event,
  Emitter<HomeState> emit,
)async{
 emit(state.copyWith(isLoading: true));
 final result = await getAllCategoryUsecase();
 result.fold(
  (failure){
    emit(state.copyWith(isLoading: false, errorMessage: failure.message));
  },
  (category){
    emit(state.copyWith(categories: category, isLoading: false));
  },
 );
}
}

