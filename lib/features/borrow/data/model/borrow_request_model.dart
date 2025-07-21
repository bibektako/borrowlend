import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/borrow_request_entity.dart';

part 'borrow_request_model.g.dart';

@JsonSerializable()
class BorrowRequestModel {
  @JsonKey(name: '_id')
  final String id;

  final _Item item;
  final _User borrower;
  final _User owner;
  final String status;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  BorrowRequestModel({
    required this.id,
    required this.item,
    required this.borrower,
    required this.owner,
    required this.status,
    required this.createdAt,
  });

  factory BorrowRequestModel.fromJson(Map<String, dynamic> json) =>
      _$BorrowRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$BorrowRequestModelToJson(this);

  BorrowRequestEntity toEntity() => BorrowRequestEntity(
        id: id,
        item: BorrowedItemEntity(
          id: item.id,
          name: item.name,
          imageUrls: item.imageUrls,
        ),
        borrower: BorrowUserEntity(
          id: borrower.id,
          username: borrower.username,
        ),
        owner: BorrowUserEntity(
          id: owner.id,
          username: owner.username,
        ),
        status: status,
      );
}

// ========== Nested Item ==========
@JsonSerializable()
class _Item {
  @JsonKey(name: '_id')
  final String id;

  final String name;
  final List<String> imageUrls;

  _Item({
    required this.id,
    required this.name,
    required this.imageUrls,
  });

  factory _Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

// ========== Nested User ==========
@JsonSerializable()
class _User {
  @JsonKey(name: '_id')
  final String id;

  final String username;

  _User({
    required this.id,
    required this.username,
  });

  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
