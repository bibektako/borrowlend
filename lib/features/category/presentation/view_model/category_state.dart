import 'package:borrowlend/features/category/domain/entity/category_entity.dart';
import 'package:equatable/equatable.dart';

class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategorySuccess extends CategoryState {
  final List<CategoryEntity> categories;

  const CategorySuccess({required this.categories});

  @override
  List<Object> get props => [categories];
}

final class CategoryFailure extends CategoryState {
  final String errorMessage;

  const CategoryFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}