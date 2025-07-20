import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/features/category/presentation/view_model/category_event.dart';
import 'package:borrowlend/features/category/presentation/view_model/category_state.dart';
import 'package:borrowlend/features/category/presentation/view_model/category_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryExplorer extends StatelessWidget {
  const CategoryExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => serviceLocator<CategoryBloc>()..add(FetchCategories()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Explore by categories',
                  style: TextStyle(fontSize: 18, fontFamily: 'Inter Bold'),
                ),
                Text(
                  'See All',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // This BlocBuilder will now listen to the CategoryBloc provided above.
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              // Now we handle the different states to build our UI
              if (state is CategoryLoading || state is CategoryInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is CategoryFailure) {
                return Center(child: Text(state.errorMessage));
              }
              if (state is CategorySuccess) {
                return SizedBox(
                  height: 100,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.categories.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      String imagePath = category.category_image;
                      if (imagePath.startsWith('/')) {
                        imagePath = imagePath.substring(1);
                      }
                      final fullImageUrl =
                          '${ApiEndpoints.serverAddress}/$imagePath';
                      return CategoryCard(
                        title: category.category.replaceAll(' ', '\n'),
                        imageUrl: fullImageUrl,
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink(); // Default empty state
            },
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const CategoryCard({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: const Offset(0, 2),
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.category, size: 28, color: Colors.grey);
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'Inter Regular',
              color: Colors.black,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
