import 'package:flutter/material.dart';

class ItemDisplayCard extends StatelessWidget {
  final String itemName;
  final String price;
  final Image image;
  const ItemDisplayCard({
    super.key,
    required this.image,
    required this.price,
    required this.itemName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      

      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(blurRadius: 4, color: Colors.blue)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: image,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              itemName,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          SizedBox(height: 8),
          Flexible(
            child: Text(
              "Rs:$price",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
