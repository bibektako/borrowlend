class OnbordingState {
  final bool isLoading;
  final bool isSuccess;

  OnbordingState({required this.isLoading, required this.isSuccess});
  OnbordingState.initial() : isLoading = false, isSuccess = false;

  OnbordingState copyWith({bool? isLoading, bool? isSuccess}) {
    return OnbordingState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
