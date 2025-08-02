import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_event.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemCard extends StatelessWidget {
  final ItemEntity item;
  final VoidCallback? onTap;

  const ItemCard({Key? key, required this.item, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    String? imageUrl;
    if (item.imageUrls.isNotEmpty) {
      String imagePath = item.imageUrls.first;
      if (imagePath.startsWith('/')) {
        imagePath = imagePath.substring(1);
      }
      imageUrl = '${ApiEndpoints.serverAddress}/$imagePath';
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Card(
        color: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 2.5,
        shadowColor: Colors.black12,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Image with bookmark ---
            AspectRatio(
              aspectRatio: 1.2,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildItemImage(imageUrl),
                  _buildBookmarkButton(context),
                ],
              ),
            ),
            _buildTextDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildItemImage(String? imageUrl) {
    return Container(
      color: Colors.grey.shade100,
      child:
          imageUrl != null
              ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder:
                    (_, __, ___) => Icon(
                      Icons.broken_image_outlined,
                      color: Colors.grey[400],
                      size: 40,
                    ),
              )
              : Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey[400],
                size: 40,
              ),
    );
  }

  Widget _buildBookmarkButton(BuildContext context) {
    final isBookmarked = item.isBookmarked;
    final theme = Theme.of(context);

    return Positioned(
      top: 8,
      right: 8,
      child: Material(
        color: Colors.white.withOpacity(0.8),
        elevation: 1,
        shape: const CircleBorder(),
        child: IconButton(
          icon: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border_outlined,
            color:
                isBookmarked
                    ? theme.colorScheme.primary
                    : theme.iconTheme.color,
            size: 22,
          ),
          onPressed: () {
            context.read<ItemViewModel>().add(
              ToggleBookmarkEvent(
                itemId: item.id!,
                isCurrentlyBookmarked: item.isBookmarked,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextDetails(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(16.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rs ${item.borrowingPrice.toStringAsFixed(0)} / day',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
              if (item.rating != null && item.rating! > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber.shade800),
                      const SizedBox(width: 4),
                      Text(
                        item.rating!.toStringAsFixed(1),
                        style: textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
