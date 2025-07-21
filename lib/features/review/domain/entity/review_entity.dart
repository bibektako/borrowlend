import 'package:equatable/equatable.dart';

class ReviewUserEntity extends Equatable {
  final String id;
  final String username;

  const ReviewUserEntity({
    required this.id,
    required this.username,
  });

  @override
  List<Object?> get props => [id, username];
}

class ReviewEntity extends Equatable {
  final String? id;
  final double rating;
  final String comment;
  final String itemId;
  final ReviewUserEntity user;
  final DateTime? createdAt;

  const ReviewEntity({
    this.id,
    required this.rating,
    required this.comment,
    required this.itemId,
    required this.user,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, rating, comment, itemId, user, createdAt];
}