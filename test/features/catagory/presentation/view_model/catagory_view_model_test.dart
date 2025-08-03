import 'package:bloc_test/bloc_test.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/category/domain/entity/category_entity.dart';
import 'package:borrowlend/features/category/domain/use_case/get_all_category_usecase.dart';
import 'package:borrowlend/features/category/presentation/view_model/category_event.dart';
import 'package:borrowlend/features/category/presentation/view_model/category_state.dart';
import 'package:borrowlend/features/category/presentation/view_model/category_viewmodel.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllCategoryUsecase extends Mock implements GetAllCategoryUsecase {}

void main() {
  late CategoryBloc bloc;
  late MockGetAllCategoryUsecase mockUsecase;

  final tCategories = [
    CategoryEntity(categoryId: '1', category: 'Books', category_image: 'uploads/book.jpg'),
    CategoryEntity(categoryId: '2', category: 'Tools', category_image: 'uploads/tool.png'),
  ];

  setUp(() {
    mockUsecase = MockGetAllCategoryUsecase();
    bloc = CategoryBloc(getAllCategoryUsecase: mockUsecase);
  });

  test('initial state is CategoryInitial', () {
    expect(bloc.state, CategoryInitial());
  });

  blocTest<CategoryBloc, CategoryState>(
    'emits [Loading, Success] when fetch succeeds',
    build: () {
      when(() => mockUsecase()).thenAnswer((_) async => Right(tCategories));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchCategories()),
    expect: () => [
      CategoryLoading(),
      CategorySuccess(categories: tCategories),
    ],
    verify: (_) => verify(() => mockUsecase()).called(1),
  );

  blocTest<CategoryBloc, CategoryState>(
    'emits [Loading, Failure] when fetch fails',
    build: () {
      when(() => mockUsecase()).thenAnswer(
        (_) async => const Left(RemoteDatabaseFailure(message: 'Error')),
      );
      return bloc;
    },
    act: (bloc) => bloc.add(FetchCategories()),
    expect: () => [
      CategoryLoading(),
      const CategoryFailure(errorMessage: 'Error'),
    ],
    verify: (_) => verify(() => mockUsecase()).called(1),
  );
}
