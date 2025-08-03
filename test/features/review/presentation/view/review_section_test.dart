import 'package:borrowlend/features/review/presentation/view/review_section.dart';
import 'package:borrowlend/features/review/presentation/view_model/review_view_model.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockReviewViewModel extends Mock implements ReviewViewModel {
  
}

class MockLoginViewModel extends Mock implements LoginViewModel {}

void main() {
  late MockReviewViewModel mockReviewViewModel;
  late MockLoginViewModel mockLoginViewModel;

  setUp(() {
    mockReviewViewModel = MockReviewViewModel();
    mockLoginViewModel = MockLoginViewModel();
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<ReviewViewModel>.value(value: mockReviewViewModel),
            BlocProvider<LoginViewModel>.value(value: mockLoginViewModel),
          ],
          child: const ReviewSection(
            itemId: 'item123',
            averageRating: 4.3,
          ),
        ),
      ),
    );
  }

  testWidgets('renders ReviewSection with average rating and text', (tester) async {
  await tester.pumpWidget(makeTestableWidget());

  expect(find.text('Reviews'), findsOneWidget);
  expect(find.text('4.3'), findsOneWidget);
  expect(find.byIcon(Icons.star_rounded), findsOneWidget);
  expect(find.widgetWithText(TextButton, 'See All'), findsOneWidget);
  expect(find.textContaining('Based on user reviews'), findsOneWidget);
});




}
