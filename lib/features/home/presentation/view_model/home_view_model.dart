// lib/features/home/presentation/view_model/home_view_model.dart
import 'package:borrowlend/features/home/presentation/view_model/home_event.dart';
import 'package:borrowlend/features/home/presentation/view_model/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewModel extends Bloc<HomeEvent, HomeState> {
  HomeViewModel() : super(const HomeState.initial()) {
    on<NavigateToPage>(_onNavigateToPage);
  }

  /// Handles navigating to any page provided in the event.
  /// This makes the ViewModel a generic navigator.
  Future<void> _onNavigateToPage(
    NavigateToPage event,
    Emitter<HomeState> emit,
  ) async {
    await Navigator.push(
      event.context,
      MaterialPageRoute(builder: (context) => event.destination),
    );
  }
}