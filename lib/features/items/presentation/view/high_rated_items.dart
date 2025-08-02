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
        final ratedItems =
            state.items
                .where((item) => item.rating != null && item.rating! >= 4.0)
                .toList();

        if (ratedItems.isEmpty) {
          return const SizedBox(); // Or a message like 'No top rated items yet.'
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with divider
              Column(
                children: [
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
                          // Optional See All action
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
                ],
              ),
              const SizedBox(height: 12),
              // Horizontal scroll of top-rated item cards
              SizedBox(
                height: 250,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  scrollDirection: Axis.horizontal,
                  itemCount: ratedItems.length,
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
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
