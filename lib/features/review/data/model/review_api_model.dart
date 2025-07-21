import 'package:borrowlend/features/review/domain/entity/review_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review_api_model.g.dart';

@JsonSerializable()
class ReviewUserApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String username;

  const ReviewUserApiModel({required this.id, required this.username});

  factory ReviewUserApiModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewUserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewUserApiModelToJson(this);
}

String _userToJson(ReviewUserApiModel user) => user.id;

@JsonSerializable(
  includeIfNull: false,
)
class ReviewApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final double rating;
  final String comment;

  @JsonKey(name: 'item_id')
  final String itemId;
  @JsonKey(name: 'user_id', toJson: _userToJson)
  final ReviewUserApiModel user;
  
  final DateTime? createdAt;


  const ReviewApiModel({
    this.id,
    required this.rating,
    required this.comment,
    required this.itemId,
    required this.user,
    this.createdAt,
  });

  factory ReviewApiModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewApiModelToJson(this);

  ReviewEntity toEntity() {
    return ReviewEntity(
      id: id,
      rating: rating,
      comment: comment,
      itemId: itemId,
      user: ReviewUserEntity(id: user.id, username: user.username),
      createdAt: createdAt,
    );
  }

  factory ReviewApiModel.fromEntity(ReviewEntity entity) {
    return ReviewApiModel(
      id: entity.id, // This will be null for a new review.
      rating: entity.rating,
      comment: entity.comment,
      itemId: entity.itemId,
      user: ReviewUserApiModel(
        id: entity.user.id,
        username: entity.user.username,
      ),
      createdAt: entity.createdAt, // This will be null for a new review.
    );
  }
}