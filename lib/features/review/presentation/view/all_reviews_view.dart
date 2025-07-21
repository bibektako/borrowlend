import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:borrowlend/features/review/domain/entity/review_entity.dart';
import 'package:borrowlend/features/review/presentation/view_model/review_event.dart';
import 'package:borrowlend/features/review/presentation/view_model/review_state.dart';
import 'package:borrowlend/features/review/presentation/view_model/review_view_model.dart';

class AllReviewsView extends StatefulWidget {
  final String itemId;

  const AllReviewsView({super.key, required this.itemId});

  @override
  State<AllReviewsView> createState() => _AllReviewsViewState();
}

class _AllReviewsViewState extends State<AllReviewsView> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewViewModel>().add(ReviewsFetched(itemId: widget.itemId));
  }

  void _showReviewForm({ReviewEntity? reviewToEdit}) {
    final ratingController = TextEditingController(
      text: reviewToEdit?.rating.toString() ?? '5.0',
    );
    final commentController = TextEditingController(
      text: reviewToEdit?.comment ?? '',
    );
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context, // The original context from the main page
      isScrollControlled: true,
      builder: (ctx) {
        // `ctx` is the NEW context for the modal sheet
        return BlocProvider.value(
          value: context.read<ReviewViewModel>(),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    reviewToEdit == null
                        ? 'Write a Review'
                        : 'Edit Your Review',
                    style: Theme.of(ctx).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: ratingController,
                    decoration: const InputDecoration(
                      labelText: 'Rating (1-5)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Rating is required.';
                      final rating = double.tryParse(value);
                      if (rating == null || rating < 1 || rating > 5) {
                        return 'Please enter a number between 1 and 5.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: commentController,
                    decoration: const InputDecoration(labelText: 'Comment'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Comment cannot be empty.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<ReviewViewModel, ReviewState>(
                    builder: (context, state) {
                      final bool isActionInProgress =
                          state is ReviewActionInProgress;
                      return ElevatedButton(
                        onPressed:
                            isActionInProgress
                                ? null
                                : () {
                                  if (formKey.currentState!.validate()) {
                                    final rating = double.parse(
                                      ratingController.text,
                                    );
                                    final comment = commentController.text;

                                    if (reviewToEdit == null) {
                                      context.read<ReviewViewModel>().add(
                                        ReviewSubmitted(
                                          rating: rating,
                                          comment: comment,
                                          itemId: widget.itemId,
                                        ),
                                      );
                                    } else {
                                      context.read<ReviewViewModel>().add(
                                        ReviewUpdated(
                                          reviewId: reviewToEdit.id!,
                                          rating: rating,
                                          comment: comment,
                                        ),
                                      );
                                    }
                                    Navigator.pop(ctx);
                                  }
                                },
                        child: Text(
                          reviewToEdit == null
                              ? 'Submit Review'
                              : 'Update Review',
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginState = context.watch<LoginViewModel>().state;
    String? currentUserId;
    if (loginState.isSuccess && loginState.user != null) {
      currentUserId = loginState.user!.userId;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Reviews'), centerTitle: true),
      body: BlocConsumer<ReviewViewModel, ReviewState>(
        listener: (context, state) {
          if (state is ReviewSuccess && state.successMessage != null) {
            final bool isError = state.successMessage!.toLowerCase().startsWith(
              'error:',
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: isError ? Colors.red : Colors.green,
              ),
            );
          } else if (state is ReviewFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ReviewInitial || state is ReviewLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ReviewFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load reviews: ${state.message}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed:
                        () => context.read<ReviewViewModel>().add(
                          ReviewsFetched(itemId: widget.itemId),
                        ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // At this point, the state must be ReviewSuccess or ReviewActionInProgress,
          // both of which contain a list of reviews.
          final reviews = switch (state) {
            ReviewSuccess(reviews: final r) => r,
            ReviewActionInProgress(reviews: final r) => r,
            _ => <ReviewEntity>[], // Should not happen due to the checks above
          };

          if (reviews.isEmpty) {
            return const Center(child: Text('No reviews yet. Be the first!'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              final isCurrentUserReview = review.user.id == currentUserId;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    review.user.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            starIndex < review.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          );
                        }),
                      ),
                      const SizedBox(height: 4),
                      Text(review.comment),
                    ],
                  ),
                  trailing:
                      isCurrentUserReview
                          ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed:
                                    () => _showReviewForm(reviewToEdit: review),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  context.read<ReviewViewModel>().add(
                                    ReviewDeleted(reviewId: review.id!),
                                  );
                                },
                              ),
                            ],
                          )
                          : null,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: BlocBuilder<ReviewViewModel, ReviewState>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed:
                state is ReviewActionInProgress
                    ? null
                    : () => _showReviewForm(),
            tooltip: 'Write a Review',
            child:
                state is ReviewActionInProgress
                    ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    )
                    : const Icon(Icons.add_comment),
          );
        },
      ),
    );
  }
}
