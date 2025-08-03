import 'package:bloc_test/bloc_test.dart';
import 'package:borrowlend/features/review/presentation/view/all_reviews_view.dart';
import 'package:borrowlend/features/review/presentation/view_model/review_view_model.dart';
import 'package:borrowlend/features/review/presentation/view_model/review_state.dart';
import 'package:borrowlend/features/review/domain/entity/review_entity.dart';
import 'package:borrowlend/features/auth/presentation/view_model/session/auth_status.dart';
import 'package:borrowlend/features/auth/presentation/view_model/session/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockReviewViewModel extends MockCubit<ReviewState> implements ReviewViewModel {}

class MockSessionCubit extends MockCubit<SessionState> implements SessionCubit {}

void main() {
  late MockReviewViewModel mockReviewViewModel;
  late MockSessionCubit mockSessionCubit;

  const itemId = 'i1';

  setUp(() {
    mockReviewViewModel = MockReviewViewModel();
    mockSessionCubit = MockSessionCubit();
  });

  Widget makeTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReviewViewModel>.value(value: mockReviewViewModel),
        BlocProvider<SessionCubit>.value(value: mockSessionCubit),
      ],
      child: const MaterialApp(
        home: AllReviewsView(itemId: itemId),
      ),
    );
  }

  testWidgets('shows loading indicator when state is ReviewLoading', (tester) async {
    when(() => mockReviewViewModel.state).thenReturn(const ReviewLoading());
    whenListen(mockReviewViewModel, Stream.value(const ReviewLoading()));
    when(() => mockSessionCubit.state).thenReturn(SessionState.unauthenticated());

    await tester.pumpWidget(makeTestableWidget());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });



  testWidgets('shows "No reviews yet" if empty', (tester) async {
    when(() => mockReviewViewModel.state).thenReturn(const ReviewSuccess(reviews: []));
    when(() => mockSessionCubit.state).thenReturn(SessionState.unauthenticated());

    await tester.pumpWidget(makeTestableWidget());
    expect(find.text('No reviews yet. Be the first!'), findsOneWidget);
  });
}
