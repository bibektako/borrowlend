import 'package:bloc_test/bloc_test.dart';
import 'package:borrowlend/features/category/domain/entity/category_entity.dart';
import 'package:borrowlend/features/category/presentation/view/category_explorer.dart';
import 'package:borrowlend/features/category/presentation/view_model/category_event.dart';
import 'package:borrowlend/features/category/presentation/view_model/category_state.dart';
import 'package:borrowlend/features/category/presentation/view_model/category_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// --- MOCK CLASSES ---
class MockCategoryBloc extends MockBloc<CategoryEvent, CategoryState>
    implements CategoryBloc {}

class FakeCategoryEvent extends Fake implements CategoryEvent {}

class FakeCategoryState extends Fake implements CategoryState {}

void main() {
  late MockCategoryBloc mockCategoryBloc;

  setUpAll(() {
    registerFallbackValue(FakeCategoryEvent());
    registerFallbackValue(FakeCategoryState());
  });

  setUp(() {
    mockCategoryBloc = MockCategoryBloc();
  });

  Future<void> pumpCategoryExplorer(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CategoryBloc>.value(
          value: mockCategoryBloc,
          child: const Scaffold(
            body: CategoryExplorer(),
          ),
        ),
      ),
    );
  }


}
