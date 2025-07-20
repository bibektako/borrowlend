import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/features/items/presentation/view/item_card.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_event.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_state.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarksView extends StatelessWidget {
  const BookmarksView({super.key});

  @override
  Widget build(BuildContext context) {
    final itemViewModel = serviceLocator<ItemViewModel>();

    if (itemViewModel.state.bookmarkedItems.isEmpty) {
      itemViewModel.add(LoadBookmarkedItemsEvent());
    }
    return BlocProvider.value(
      value: itemViewModel,

      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Bookmarks'),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ItemViewModel>().add(LoadBookmarkedItemsEvent());
          },
          child: BlocBuilder<ItemViewModel, ItemState>(
            builder: (context, state) {
              // 1. Handle the Loading State
              if (state.status == ItemStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == ItemStatus.failure) {
                return Center(
                  child: Text(
                    state.errorMessage ?? 'Could not load bookmarks.',
                  ),
                );
              }

              if (state.bookmarkedItems.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      'You have no saved items yet.\nTap the bookmark icon on an item to save it here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.80,
                ),
                itemCount: state.bookmarkedItems.length,
                itemBuilder: (context, index) {
                  final item = state.bookmarkedItems[index];
                  return ItemCard(item: item);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
