// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrow_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BorrowRequestModel _$BorrowRequestModelFromJson(Map<String, dynamic> json) =>
    BorrowRequestModel(
      id: json['_id'] as String,
      item: _Item.fromJson(json['item'] as Map<String, dynamic>),
      borrower: _User.fromJson(json['borrower'] as Map<String, dynamic>),
      owner: _User.fromJson(json['owner'] as Map<String, dynamic>),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$BorrowRequestModelToJson(BorrowRequestModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'item': instance.item,
      'borrower': instance.borrower,
      'owner': instance.owner,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_Item _$ItemFromJson(Map<String, dynamic> json) => _Item(
      id: json['_id'] as String,
      name: json['name'] as String,
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ItemToJson(_Item instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'imageUrls': instance.imageUrls,
    };

_User _$UserFromJson(Map<String, dynamic> json) => _User(
      id: json['_id'] as String,
      username: json['username'] as String,
    );

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
    };
