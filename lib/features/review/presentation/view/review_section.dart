import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:borrowlend/features/review/presentation/view/all_reviews_view.dart';
import 'package:borrowlend/features/review/presentation/view_model/review_view_model.dart';

class ReviewSection extends StatelessWidget {
  final String itemId;
  final double averageRating;

  const ReviewSection({
    super.key,
    required this.itemId,
    required this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Reviews",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: context.read<ReviewViewModel>(),
                              ),
                              BlocProvider.value(
                                value: context.read<LoginViewModel>(),
                              ),
                            ],
                            child: AllReviewsView(itemId: itemId),
                          ),
                    ),
                  );
                },
                child: const Text("See All"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor.withOpacity(0.15)),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(
                averageRating.toStringAsFixed(1),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.star_rounded, color: Colors.amber, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  "Based on user reviews. Tap 'See All' to read more or write your own.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
