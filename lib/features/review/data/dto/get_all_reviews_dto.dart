import 'package:borrowlend/features/review/data/model/review_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_all_reviews_dto.g.dart';

@JsonSerializable()
class GetAllReviewsDto {
  final bool success;
  final String message;
  final List<ReviewApiModel> data;

  const GetAllReviewsDto({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetAllReviewsDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllReviewsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllReviewsDtoToJson(this);
}