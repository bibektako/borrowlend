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

  const ItemEntity({
     this.id,
    required this.name,
    required this.imageUrls,
    required this.description,
    required this.borrowingPrice,
     this.rating,
     this.owner,
    required this.category,
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
      ];
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
  List<Object?> get props => [id, username, location];
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