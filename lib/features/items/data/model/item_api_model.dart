import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ItemApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String description;
  final List<String>? imageUrls;
  final double? borrowingPrice;
  final double? rating;
  final int? numReviews;
  final OwnerApiModel? owner;
  final CategoryApiModel? category;

  const ItemApiModel({
    this.id,
    this.name,
    required this.description,
    this.imageUrls,
    this.borrowingPrice,
    this.rating,
    this.numReviews,
    this.owner,
    this.category,
  });

  factory ItemApiModel.fromJson(Map<String, dynamic> json) =>
      _$ItemApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemApiModelToJson(this);

  ItemEntity toEntity({bool isBookmarked = false}) {
    return ItemEntity(
      id: id ?? '',
      name: name ?? 'Unnamed Item',
      description: description,
      imageUrls: imageUrls ?? [],
      borrowingPrice: borrowingPrice ?? 0.0,
      rating: rating ?? 0.0,
      owner: owner?.toEntity(),
      category:
          category?.toEntity() ??
          const CategoryEntity(id: '', name: 'Uncategorized'),
      isBookmarked: isBookmarked,
    );
  }

  factory ItemApiModel.fromEntity(ItemEntity entity) {
    return ItemApiModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      imageUrls: entity.imageUrls,
      borrowingPrice: entity.borrowingPrice,
      category: CategoryApiModel.fromEntity(entity.category),
    );
  }

  static List<ItemEntity> toEntityList(List<ItemApiModel> models) {
    return models.map((model) => model.toEntity(isBookmarked: false)).toList();
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrls,
    borrowingPrice,
    rating,
    numReviews,
    owner,
    category,
  ];
}

@JsonSerializable()
class OwnerApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String username;
  final String? location;

  const OwnerApiModel({
    required this.id,
    required this.username,
    this.location,
  });

  factory OwnerApiModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerApiModelToJson(this);

  OwnerEntity toEntity() =>
      OwnerEntity(id: id, username: username, location: location);

  @override
  List<Object?> get props => [id, username, location];
}

@JsonSerializable()
class CategoryApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String name;

  const CategoryApiModel({required this.id, required this.name});

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryApiModelToJson(this);

  CategoryEntity toEntity() => CategoryEntity(id: id, name: name);

  factory CategoryApiModel.fromEntity(CategoryEntity entity) =>
      CategoryApiModel(id: entity.id, name: entity.name);

  @override
  List<Object?> get props => [id, name];
}
