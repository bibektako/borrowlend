import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

@immutable
sealed class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

final class ReviewsFetched extends ReviewEvent {
  final String itemId;

  const ReviewsFetched({required this.itemId});

  @override
  List<Object> get props => [itemId];
}

final class ReviewSubmitted extends ReviewEvent {
  final double rating;
  final String comment;
  final String itemId;

  const ReviewSubmitted({
    required this.rating,
    required this.comment,
    required this.itemId,
  });

  @override
  List<Object> get props => [rating, comment, itemId];
}

final class ReviewUpdated extends ReviewEvent {
  final String reviewId;
  final double rating;
  final String comment;

  const ReviewUpdated({
    required this.reviewId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object> get props => [reviewId, rating, comment];
}

/// Event to delete a review.
final class ReviewDeleted extends ReviewEvent {
  final String reviewId;

  const ReviewDeleted({
    required this.reviewId,
  });

  @override
  List<Object> get props => [reviewId];
}