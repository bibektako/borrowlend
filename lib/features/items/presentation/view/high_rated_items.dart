import 'package:borrowlend/features/items/presentation/view/item_card.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_state.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HighRatedItems extends StatelessWidget {
  const HighRatedItems({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ItemViewModel, ItemState>(
      builder: (context, state) {
        // Filter and sort items with rating >= 4.0
        final ratedItems =
            state.items
                .where((item) => item.rating != null && item.rating! >= 1.0)
                .toList()
              ..sort((a, b) => b.rating!.compareTo(a.rating!)); // Descending

        if (ratedItems.isEmpty) {
          return const SizedBox(); // Or show a message
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Top Rated Items",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Optional See All navigation
                    },
                    child: Text(
                      "See All",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 1, color: Colors.grey),
              const SizedBox(height: 12),

              // Horizontal List of Cards
              SizedBox(
                height: 250,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: ratedItems.length,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = ratedItems[index];
                    return SizedBox(
                      width: 170,
                      child: ItemCard(
                        item: item,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/item-detail',
                            arguments: item,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
