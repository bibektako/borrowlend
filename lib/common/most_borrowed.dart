import 'package:borrowlend/common/item_display_card.dart';
import 'package:flutter/material.dart';

class MostBorrowed extends StatelessWidget {
  const MostBorrowed({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        "itemName": "XGIMI Projector",
        "image": Image.network(
          'https://www.olizstore.com/media/catalog/product/cache/efed489c73f153d334cfb652c25a982f/x/g/xgimi_mogo_2_pro_400_lumen_1682598915_1762236.jpg',
        ),
        "price": "5000",
      },
      {
        "itemName": "Coofix 25 Volt Cordless drill",
        "image": Image.network(
          'https://hardwarepasal.com/src/img/product/2020-01-17-06-44-02_cAve9ddO7Tproduct.jpg',
        ),
        "price": "999",
      },
      {
        "itemName": "Item Name",
        "image": Image.network(
          'https://www.creativefabrica.com/wp-content/uploads/2021/04/05/Photo-Image-Icon-Graphics-10388619-1-1-580x386.jpg',
        ),
        "price": "999",
      },
      {
        "itemName": "Item Name",
        "image": Image.network(
          'https://www.creativefabrica.com/wp-content/uploads/2021/04/05/Photo-Image-Icon-Graphics-10388619-1-1-580x386.jpg',
        ),
        "price": "999",
      },
      {
        "itemName": "Item Name",
        "image": Image.network(
          'https://www.creativefabrica.com/wp-content/uploads/2021/04/05/Photo-Image-Icon-Graphics-10388619-1-1-580x386.jpg',
        ),
        "price": "999",
      },
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Most borrowed items",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Inter Bold',
                  color: Colors.black,
                ),
              ),
              Text(
                "See All",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter Semibold',
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 250,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemBuilder: (context, index) {
              return ItemDisplayCard(
                image: items[index]['image'],
                price: items[index]['price'],
                itemName: items[index]['itemName'],
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }
}
