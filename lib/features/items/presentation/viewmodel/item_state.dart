import 'package:borrowlend/features/category/domain/entity/category_entity.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:equatable/equatable.dart';

enum ItemStatus { initial, loading, success, failure }

enum FormStatus { initial, loading, success, failure }


class ItemState extends Equatable {
  final ItemStatus status;

  final List<ItemEntity> items;
  final List<ItemEntity> bookmarkedItems;
    final List<ItemEntity> myItems; 

  final Set<String> bookmarkedItemIds;

    final String? errorMessage;

  // state for edit and delete items

  final FormStatus formStatus;
  final String name;
  final String description;
  final String price;
  final List<String> imagePaths;
  final CategoryEntity selectedCategory;
  final ItemEntity? itemToEdit;


  const ItemState({
    required this.status,
    required this.items,
    required this.bookmarkedItems,
    required this.bookmarkedItemIds,
    required this.myItems,
    

    this.errorMessage,

     required this.formStatus,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePaths,
    required this.selectedCategory,
    this.itemToEdit,

  });

  factory ItemState.initial() {
    return const ItemState(
      status: ItemStatus.initial,
      items: [],
      bookmarkedItems: [],
      bookmarkedItemIds: {},
      myItems: [],

      errorMessage: null,

      formStatus: FormStatus.initial,
      name: '',
      description: '',
      price: '',
      imagePaths: [],
      selectedCategory: CategoryEntity(categoryId: '', category: 'Select a Category', category_image: ''),
      itemToEdit: null,
    );
  }

  ItemState copyWith({
    ItemStatus? status,
    List<ItemEntity>? items,
    List<ItemEntity>? bookmarkedItems,
    Set<String>? bookmarkedItemIds,
      List<ItemEntity>? myItems, // <-- ADD TO copyWith

    String? errorMessage,


     FormStatus? formStatus,
    String? name,
    String? description,
    String? price,
    List<String>? imagePaths,
    CategoryEntity? selectedCategory,
    ItemEntity? itemToEdit,
  }) {
    return ItemState(
      status: status ?? this.status,
      items: items ?? this.items,
      bookmarkedItems: bookmarkedItems ?? this.bookmarkedItems,
      bookmarkedItemIds:
          bookmarkedItemIds ?? this.bookmarkedItemIds, 
      myItems: myItems ?? this.myItems,

      errorMessage:
          status == ItemStatus.failure
              ? (errorMessage ?? this.errorMessage)
              : null,

      
      formStatus: formStatus ?? this.formStatus,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imagePaths: imagePaths ?? this.imagePaths,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      itemToEdit: itemToEdit ?? this.itemToEdit,
    );
  }

  @override
  List<Object?> get props => [status, items, bookmarkedItems,myItems, errorMessage , formStatus, name, description,price,imagePaths, selectedCategory, itemToEdit];
}
