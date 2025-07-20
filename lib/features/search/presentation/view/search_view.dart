import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/presentation/view/item_card.dart';
import 'package:borrowlend/features/items/presentation/view/item_detail_view.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';
import 'package:borrowlend/features/search/presentation/view_model/search_event.dart';
import 'package:borrowlend/features/search/presentation/view_model/search_state.dart';
import 'package:borrowlend/features/search/presentation/view_model/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  serviceLocator<SearchViewModel>()
                    ..add(FetchAllItemsForSearch()),
        ),
        BlocProvider.value(value: serviceLocator<ItemViewModel>()),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Search & Discover')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _SearchBar(),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<SearchViewModel, SearchState>(
                  builder: (context, state) {
                    if (state.status == SearchStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.status == SearchStatus.failure) {
                      return Center(
                        child: Text(state.errorMessage ?? 'An error occurred.'),
                      );
                    }

                    final bool isSearching = state.searchTerm.isNotEmpty;

                    final List<ItemEntity> itemsToDisplay =
                        isSearching ? state.searchResults : state.allItems;

                    if (itemsToDisplay.isEmpty) {
                      if (isSearching) {
                        return Center(
                          child: Text(
                            'No results found for "${state.searchTerm}"',
                          ),
                        );
                      }
                      return const Center(
                        child: Text('No items available to display.'),
                      );
                    }

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.80,
                          ),
                      itemCount: itemsToDisplay.length,
                      itemBuilder: (context, index) {
                        final item = itemsToDisplay[index];
                        return ItemCard(
                          item: item,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) => BlocProvider.value(
                                      value: context.read<ItemViewModel>(),
                                      child: ItemDetailView(item: item),
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Search for items by name...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _controller.clear();
            context.read<SearchViewModel>().add(ClearSearch());
          },
        ),
      ),
      onChanged: (value) {
        context.read<SearchViewModel>().add(SearchTermChanged(value));
      },
    );
  }
}
