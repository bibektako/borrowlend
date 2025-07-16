import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  const HomeState({
    required this.isLoading,
    required this.errorMessage,
  });

  const HomeState.initial()
    : 
      isLoading = false,
      errorMessage = null;

  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage];
}
