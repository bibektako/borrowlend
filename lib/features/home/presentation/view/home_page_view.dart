import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/core/common/shake_detector_wrapper.dart';
import 'package:borrowlend/core/common/slider_screen.dart';
import 'package:borrowlend/features/category/presentation/view/category_explorer.dart';
import 'package:borrowlend/features/home/presentation/view_model/home_event.dart';
import 'package:borrowlend/features/home/presentation/view_model/home_view_model.dart';
import 'package:borrowlend/features/items/presentation/view/high_rated_items.dart';
import 'package:borrowlend/features/items/presentation/view/item_card.dart';
import 'package:borrowlend/features/items/presentation/view/item_detail_view.dart';
import 'package:borrowlend/features/items/presentation/view/most_borrowed.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_event.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_state.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';
import 'package:borrowlend/features/search/presentation/view/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeViewModel()),
        BlocProvider.value(
          value: serviceLocator<ItemViewModel>()..add(LoadAllItemsEvent()),
        ),
      ],
      child: Scaffold(body: const _HomePageContent()),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GlobalShakeDetector().start(context);
    });
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SliderScreen(),
            const SizedBox(height: 18),

            // Styled search bar
            GestureDetector(
              onTap: () {
                context.read<HomeViewModel>().add(
                  NavigateToPage(context: context, destination: SearchView()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[700]),
                    const SizedBox(width: 10),
                    Text(
                      'Search for items...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Categories
            CategoryExplorer(),
            const SizedBox(height: 24),

            // Featured Section
            const MostBorrowed(),
            const SizedBox(height: 18),
            const HighRatedItems(),
            const SizedBox(height: 24),

            // More items
            Text(
              "View more items",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<ItemViewModel, ItemState>(
              builder: (context, state) {
                if (state.status == ItemStatus.loading && state.items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.items.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text('No items to display.'),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.items.length,
                  padding: const EdgeInsets.only(bottom: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.80,
                  ),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
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
          ],
        ),
      ),
    );
  }
}
