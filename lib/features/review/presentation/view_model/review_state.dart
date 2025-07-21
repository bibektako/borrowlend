import 'package:borrowlend/features/review/domain/entity/review_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

final class ReviewInitial extends ReviewState {
  const ReviewInitial();
}

final class ReviewLoading extends ReviewState {
  const ReviewLoading();
}

final class ReviewActionInProgress extends ReviewState {
    final List<ReviewEntity> reviews;

    const ReviewActionInProgress(this.reviews);

    @override
    List<Object?> get props => [reviews];
}


final class ReviewSuccess extends ReviewState {
  final List<ReviewEntity> reviews;
  final String? successMessage; 

  const ReviewSuccess({
    required this.reviews,
    this.successMessage,
  });

  @override
  List<Object?> get props => [reviews, successMessage];
}

final class ReviewFailure extends ReviewState {
  final String message;

  const ReviewFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

final class ReviewNavigation extends ReviewState {
    final String itemId;
    const ReviewNavigation({required this.itemId});

    @override
    List<Object?> get props => [itemId];
}