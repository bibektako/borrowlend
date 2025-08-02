import 'package:borrowlend/core/common/snackbar/my_snackbar.dart';
import 'package:borrowlend/features/auth/presentation/view_model/session/auth_status.dart';
import 'package:borrowlend/features/auth/presentation/view_model/session/session_cubit.dart';
import 'package:borrowlend/features/review/domain/entity/review_entity.dart';
import 'package:borrowlend/features/review/presentation/view_model/review_event.dart';
import 'package:borrowlend/features/review/presentation/view_model/review_state.dart';
import 'package:borrowlend/features/review/presentation/view_model/review_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return BlocProvider.value(
          value: context.read<ReviewViewModel>(),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
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
                  StatefulBuilder(
                    builder: (ctx, setModalState) {
                      double selectedRating =
                          double.tryParse(ratingController.text) ?? 5.0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rating:',
                            style: Theme.of(ctx).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: List.generate(5, (index) {
                              return IconButton(
                                onPressed: () {
                                  setModalState(() {
                                    selectedRating = index + 1.0;
                                    ratingController.text =
                                        selectedRating.toString();
                                  });
                                },
                                icon: Icon(
                                  index < selectedRating
                                      ? Icons.star_rounded
                                      : Icons.star_border_rounded,
                                  color: Colors.amber,
                                  size: 30,
                                ),
                                splashRadius: 20,
                              );
                            }),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: commentController,
                    decoration: const InputDecoration(labelText: 'Comment'),
                    maxLines: 3,
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? 'Comment cannot be empty.'
                                : null,
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<ReviewViewModel, ReviewState>(
                    builder: (context, state) {
                      final isLoading = state is ReviewActionInProgress;
                      return ElevatedButton(
                        onPressed:
                            isLoading
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmDeleteReview(BuildContext context, String reviewId) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Delete Review'),
            content: const Text('Are you sure you want to delete this review?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.read<ReviewViewModel>().add(
                    ReviewDeleted(reviewId: reviewId),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = context.watch<SessionCubit>().state;
    final currentUserId =
        sessionState.status == AuthStatus.authenticated
            ? sessionState.user?.userId
            : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Reviews'), centerTitle: true),
      body: BlocConsumer<ReviewViewModel, ReviewState>(
        listener: (context, state) {
          if (state is ReviewSuccess && state.successMessage != null) {
            final msg = state.successMessage!;
            final isError = msg.toLowerCase().startsWith('error:');
            showMySnackBar(
              context: context,
              message: msg,
              type: isError ? SnackBarType.error : SnackBarType.success,
            );
          } else if (state is ReviewFailure) {
            showMySnackBar(
              context: context,
              message: state.message,
              type: SnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          if (state is ReviewInitial || state is ReviewLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final reviews = switch (state) {
            ReviewSuccess(reviews: final r) => r,
            ReviewActionInProgress(reviews: final r) => r,
            _ => <ReviewEntity>[],
          };

          if (reviews.isEmpty) {
            return const Center(child: Text('No reviews yet. Be the first!'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              final isCurrentUser = review.user.id == currentUserId;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    review.user.username,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < review.rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(review.comment),
                    ],
                  ),
                  trailing:
                      isCurrentUser
                          ? PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showReviewForm(reviewToEdit: review);
                              } else if (value == 'delete') {
                                _confirmDeleteReview(context, review.id!);
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            itemBuilder:
                                (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      title: Text('Edit'),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      title: Text('Delete'),
                                    ),
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
                      strokeWidth: 2.5,
                    )
                    : const Icon(Icons.add_comment_rounded),
          );
        },
      ),
    );
  }
}
