import 'package:equatable/equatable.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

class FetchAllItemsForSearch extends SearchEvent {}

class SearchTermChanged extends SearchEvent {
  final String term;
  const SearchTermChanged(this.term);
}


class ClearSearch extends SearchEvent {}