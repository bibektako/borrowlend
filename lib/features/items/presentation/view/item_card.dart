import 'package:flutter/material.dart';

import 'package:borrowlend/features/items/domain/entity/item_entity.dart';

class ItemCard extends StatelessWidget {
  final ItemEntity item;

  const ItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is the full URL that the app will use to fetch the image.
    // Example: http://localhost:5050/public/uploads/image-1752573001509.jpeg
    // You MUST configure your ApiService or a constant file with the base URL.
    const String baseUrl = "http://localhost:5050/"; // <-- IMPORTANT!

    final String? imageUrl =
        item.imageUrls.isNotEmpty ? baseUrl + item.imageUrls.first : null;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 4.0,
      clipBehavior: Clip.antiAlias, // This is crucial for the Stack
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildItemImage(imageUrl),

          _buildGradientScrim(),

          _buildTextDetails(),
        ],
      ),
    );
  }

  Widget _buildItemImage(String? imageUrl) {
    if (imageUrl != null) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: Icon(
              Icons.broken_image_outlined,
              color: Colors.grey[400],
              size: 40,
            ),
          );
        },
      );
    } else {
      return Container(
        color: Colors.grey[200],
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey[400],
          size: 40,
        ),
      );
    }
  }

  Widget _buildGradientScrim() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.5, 1.0], // Gradient starts halfway down
          ),
        ),
      ),
    );
  }

  Widget _buildTextDetails() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text for readability
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\Rs${item.borrowingPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 20.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      (item.rating ?? 0.0).toString(),
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
