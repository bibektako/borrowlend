import 'package:borrowlend/features/category/data/model/category_api_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'category_dto.g.dart';

@JsonSerializable()
class CategoryDto{
  final bool success;
  final int count;
  final List<CategoryApiModel> data;

  const CategoryDto({
    required this.success,
    required this.count,
    required this.data,


  });

  Map<String,dynamic> toJson()=> _$CategoryDtoToJson(this);

  factory CategoryDto.fromJson(Map<String,dynamic> json)=> _$CategoryDtoFromJson(json);
}
