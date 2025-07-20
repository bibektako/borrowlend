import 'package:equatable/equatable.dart';

class ItemEntity extends Equatable {
  final String? id;
  final String name;
  final List<String> imageUrls;
  final String description;
  final double borrowingPrice;
  final double? rating;
  final OwnerEntity? owner;
  final CategoryEntity category;
  final bool isBookmarked;

  const ItemEntity({
     this.id,
    required this.name,
    required this.imageUrls,
    required this.description,
    required this.borrowingPrice,
     this.rating,
     this.owner,
    required this.category,
    this.isBookmarked = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrls,
        description,
        borrowingPrice,
        rating,
        owner,
        category,
        isBookmarked
      ];

  ItemEntity copyWith({
    String? id,
    String? name,
    List<String>? imageUrls,
    String? description,
    double? borrowingPrice,
    double? rating,
    OwnerEntity? owner,
    CategoryEntity? category,
    bool? isBookmarked,
  }) {
    return ItemEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrls: imageUrls ?? this.imageUrls,
      description: description ?? this.description,
      borrowingPrice: borrowingPrice ?? this.borrowingPrice,
      rating: rating ?? this.rating,
      owner: owner ?? this.owner,
      category: category ?? this.category,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}


class OwnerEntity extends Equatable {
  final String id;
  final String username;
  final String? location;
  

  const OwnerEntity({
    required this.id,
    required this.username,
    this.location,
  });

  @override
  List<Object?> get props => [id, username, location, ];
}

class CategoryEntity extends Equatable {
  final String id;
  final String name;

  const CategoryEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}