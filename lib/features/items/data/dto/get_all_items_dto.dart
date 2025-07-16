import 'package:borrowlend/features/items/data/model/item_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_all_items_dto.g.dart';

@JsonSerializable()
class GetAllItemsDto {
  final bool success;
  final int count;
  final List<ItemApiModel> data;

  const GetAllItemsDto({
    required this.success,
    required this.count,
    required this.data,
  });

  // From json
  factory GetAllItemsDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllItemsDtoFromJson(json);

  // To json
  Map<String, dynamic> toJson() => _$GetAllItemsDtoToJson(this);
}