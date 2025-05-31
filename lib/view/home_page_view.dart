import 'package:borrowlend/common/app_header.dart';
import 'package:borrowlend/common/category_explorer.dart';
import 'package:borrowlend/common/item_display_card.dart';
import 'package:borrowlend/common/most_borrowed.dart';
import 'package:borrowlend/common/slider_screen.dart';
import 'package:borrowlend/view/search_view.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SliderScreen(),
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchView()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: 361,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xffE4E7EC),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        width: 2,
                        color: const Color(0xffE4E7EC),
                      ),
                      boxShadow: const [
                        BoxShadow(blurRadius: 4, color: Colors.grey),
                      ],
                    ),
                    alignment: Alignment.centerLeft,
                    child: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 18),
                CategoryExplorer(),
                const SizedBox(height: 18),
                MostBorrowed(),
                const SizedBox(height: 18),
                MostBorrowed(),
                const SizedBox(height: 18),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "View more items",
                      style: TextStyle(fontFamily: 'Inter Bold', fontSize: 20),
                    ),
                    SizedBox(height: 18),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 14,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 0.80,
                      children: [
                        for (int i = 0; i < 10; i++) ...{
                          SizedBox(
                            height: 250,
                            child: ItemDisplayCard(
                              image: Image.network(
                                'https://www.creativefabrica.com/wp-content/uploads/2021/04/05/Photo-Image-Icon-Graphics-10388619-1-1-580x386.jpg',
                                fit: BoxFit.cover,
                              ),
                              itemName: 'Name',
                              price: '000',
                            ),
                          ),
                        },
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
