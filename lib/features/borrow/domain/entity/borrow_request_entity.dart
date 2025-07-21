import 'package:equatable/equatable.dart';

// Entity for the item being borrowed
class BorrowedItemEntity extends Equatable {
  final String id;
  final String name;
  final List<String> imageUrls;

  const BorrowedItemEntity({
    required this.id,
    required this.name,
    required this.imageUrls,
  });

  @override
  List<Object?> get props => [id, name, imageUrls];
}

// Entity for user (owner/borrower)
class BorrowUserEntity extends Equatable {
  final String id;
  final String username;

  const BorrowUserEntity({
    required this.id,
    required this.username,
  });

  @override
  List<Object?> get props => [id, username];
}

// Main BorrowRequestEntity
class BorrowRequestEntity extends Equatable {
  final String? id;
  final BorrowedItemEntity item;
  final BorrowUserEntity borrower;
  final BorrowUserEntity owner;
  final String status;

  const BorrowRequestEntity({
    this.id,
    required this.item,
    required this.borrower,
    required this.owner,
    required this.status,
  });

  @override
  List<Object?> get props => [id, item, borrower, owner, status];
}
