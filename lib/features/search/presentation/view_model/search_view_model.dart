import 'package:borrowlend/features/items/domain/use_case/get_all_items_usecase.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';
import 'package:borrowlend/features/search/presentation/view_model/search_event.dart';
import 'package:borrowlend/features/search/presentation/view_model/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart'; 

class SearchViewModel extends Bloc<SearchEvent, SearchState> {
  final GetAllItemsUsecase _getAllItemsUsecase;
  final ItemViewModel _itemViewModel;

  SearchViewModel({
    required GetAllItemsUsecase getAllItemsUsecase,
    required ItemViewModel itemViewModel,
  })  : _getAllItemsUsecase = getAllItemsUsecase,
        _itemViewModel = itemViewModel,
        super(const SearchState()) {
    on<SearchTermChanged>(
      _onSearchTermChanged,
      transformer: (events, mapper) => events.debounceTime(const Duration(milliseconds: 500)).switchMap(mapper),
    );
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onSearchTermChanged(SearchTermChanged event, Emitter<SearchState> emit) async {

    if (event.term.isEmpty) {
      emit(state.copyWith(searchResults: [], status: SearchStatus.initial, searchTerm: ''));
      return;
    }
    
    emit(state.copyWith(status: SearchStatus.loading, searchTerm: event.term));
    
    final result = await _getAllItemsUsecase({'search': event.term});
    
    result.fold(
      (failure) => emit(state.copyWith(status: SearchStatus.failure, errorMessage: failure.message)),
      (items) => emit(state.copyWith(status: SearchStatus.success, searchResults: items)),
    );
  }
  
  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(state.copyWith(searchResults: [], status: SearchStatus.initial, searchTerm: ''));
  }
}