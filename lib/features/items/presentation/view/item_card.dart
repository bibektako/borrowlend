import 'package:borrowlend/app/constant/api_endpoints.dart'; // 1. IMPORT YOUR API CONSTANTS
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
      borderRadius: BorderRadius.circular(12.0),

      child: Card(
        elevation: 2.0,
        shadowColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: Colors.grey.shade100, // A subtle background for the image
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildItemImage(imageUrl),
                    _buildBookmarkButton(context),
                  ],
                ),
              ),
            ),
            _buildTextDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildItemImage(String? imageUrl) {
    if (imageUrl != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain, // Shows the full image without cropping
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2.0),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.broken_image_outlined,
              color: Colors.grey[400],
              size: 40,
            );
          },
        ),
      );
    } else {
      return Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey[400],
        size: 40,
      );
    }
  }

  Widget _buildBookmarkButton(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: IconButton(
          icon: Icon(
            item.isBookmarked ? Icons.bookmark : Icons.bookmark_border_outlined,
            color:
                item.isBookmarked
                    ? Theme.of(context).primaryColor
                    : Colors.black54,
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
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '\Rs${item.borrowingPrice.toStringAsFixed(0)} / day',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              if (item.rating != null && item.rating! > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber.shade800,
                        size: 14.0,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        item.rating!.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 12.0,
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
