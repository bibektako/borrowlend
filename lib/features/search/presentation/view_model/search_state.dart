import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:equatable/equatable.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final String searchTerm;
  final List<ItemEntity> searchResults;
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.searchTerm = '',
    this.searchResults = const [],
    this.errorMessage,
  });

  SearchState copyWith({
    SearchStatus? status,
    String? searchTerm,
    List<ItemEntity>? searchResults,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      searchTerm: searchTerm ?? this.searchTerm,
      searchResults: searchResults ?? this.searchResults,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, searchTerm, searchResults, errorMessage];
}