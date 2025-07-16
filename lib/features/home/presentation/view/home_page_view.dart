import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/core/common/most_borrowed.dart';
import 'package:borrowlend/core/common/slider_screen.dart';
import 'package:borrowlend/features/category/presentation/view/category_explorer.dart';
import 'package:borrowlend/features/items/presentation/view/item_card.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_event.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_state.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';
import 'package:borrowlend/view/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ItemViewModel>()
          ..add(LoadAllItemsEvent()),
      child: Scaffold(
        appBar: AppBar(),
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SliderScreen(),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchView()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: 361,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xffE4E7EC),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      alignment: Alignment.centerLeft,
                      child: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 18),
                  CategoryExplorer(),
                  const SizedBox(height: 18),
                  MostBorrowed(),
                  const SizedBox(height: 18),
                  MostBorrowed(),
                  const SizedBox(height: 18),
          
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "View more items",
                        style: TextStyle(fontFamily: 'Inter Bold', fontSize: 20),
                      ),
                      const SizedBox(height: 18),
                      BlocBuilder<ItemViewModel, ItemState>(
                        builder: (context, state) {
                          if (state.isLoading && state.items.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
          
                          if (state.errorMessage != null) {
                            return Center(
                                child: Text('Error: ${state.errorMessage}'));
                          }
          
                          if (state.items.isEmpty) {
                            return const Center(
                                child: Text('No items to display.'));
                          }
          
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.80,
                            ),
                            itemCount: state.items.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = state.items[index];
                              return ItemCard(item: item);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        
      ),
    );
  }
}