import 'package:borrowlend/features/items/presentation/view/item_card.dart';
import 'package:borrowlend/features/items/presentation/view/item_detail_view.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_state.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MostBorrowed extends StatefulWidget {
  const MostBorrowed({super.key});

  @override
  State<MostBorrowed> createState() => _MostBorrowedState();
}

class _MostBorrowedState extends State<MostBorrowed> {
  final PageController _pageController = PageController(viewportFraction: 0.5);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ItemViewModel, ItemState>(
      builder: (context, state) {
        if (state.status == ItemStatus.loading && state.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.items.isEmpty) {
          return const Center(child: Text("No items available."));
        }

        final topItems = state.items.take(5).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with gradient underline
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShaderMask(
                      shaderCallback:
                          (bounds) => const LinearGradient(
                            colors: [Color(0xFF5D9EFF), Color(0xFF8867E9)],
                          ).createShader(bounds),
                      child: Text(
                        "Most Borrowed",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "See All",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF5D9EFF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 2,
                width: 50,
                margin: const EdgeInsets.only(left: 4),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5D9EFF), Color(0xFF8867E9)],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),

              // Carousel of cards
              SizedBox(
                height: 260,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: topItems.length,
                  itemBuilder: (context, index) {
                    final item = topItems[index];

                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (_pageController.position.haveDimensions) {
                          final currentPage = _pageController.page ?? index;
                          final difference = currentPage - index;
                          final rawValue = 1.0 - (difference.abs() * 0.3);
                          value = rawValue.clamp(0.85, 1.0) as double;
                        }

                        return Align(
                          alignment: Alignment.topCenter,
                          child: Transform.scale(
                            scale: Curves.easeOut.transform(value),
                            child: GestureDetector(
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
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: ItemCard(item: item),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
