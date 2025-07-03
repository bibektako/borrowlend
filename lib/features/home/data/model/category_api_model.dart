import 'package:borrowlend/features/home/domain/entity/category_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_api_model.g.dart';

@JsonSerializable()
class CategoryApiModel extends Equatable{
  @JsonKey(name: '_id')
  final String? categoryId;
  final String category;
  final String category_image;

  const CategoryApiModel({
    this.categoryId,
    required this.category,
    required this.category_image
    
  });
  const CategoryApiModel.empty() : categoryId ='', category = '', category_image = '';

  factory CategoryApiModel.fromJson(Map<String,dynamic> json){
    return CategoryApiModel(categoryId: json['_id'],category: json['name'], category_image: json['imageUrl']);
  }

  Map<String,dynamic> toJson(){
    return{'category': category, 'category_image':category_image};
  }

  CategoryEntity toEntity() => CategoryEntity(categoryId: categoryId,category: category, category_image: category_image);

  static CategoryApiModel fromEntity(CategoryEntity entity) =>
    CategoryApiModel(categoryId: entity.categoryId,category: entity.category, category_image: entity.category_image);

static List<CategoryEntity> toEntityList(List<CategoryApiModel>model) =>
  model.map((model) => model.toEntity()).toList();
  @override
  List<Object?> get props => [categoryId, category, category_image];
}