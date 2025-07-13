import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
final String? categoryId;
final String category;
final String category_image;

const CategoryEntity({
  this.categoryId,
  required this.category,
  required this.category_image
});

  @override
  List<Object?> get props => [categoryId,category,category_image];
}