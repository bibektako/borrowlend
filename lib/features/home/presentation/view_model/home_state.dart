import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:borrowlend/features/home/domain/entity/category_entity.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final List<CategoryEntity> categories;
  final bool isLoading;
  final String? errorMessage;

  const HomeState({
    required this.categories,
    required this.isLoading,
    required this.errorMessage,
  });

  const HomeState.initial()
    : categories = const [],
      isLoading = false,
      errorMessage = null;

  HomeState copyWith({
    List<CategoryEntity>? categories,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [categories, isLoading, errorMessage];
}
