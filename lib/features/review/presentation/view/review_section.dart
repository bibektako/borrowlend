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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Reviews",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Text(
                averageRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.star, color: Colors.amber, size: 32),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  "Based on user reviews. Tap 'See All' to read more or write your own.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
