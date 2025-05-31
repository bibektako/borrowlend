import 'package:borrowlend/common/app_header.dart';
import 'package:borrowlend/common/category_explorer.dart';
import 'package:borrowlend/common/most_borrowed.dart';
import 'package:borrowlend/common/slider_screen.dart';
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
      body: Column(
        children: [
          AppHeader(),
          SliderScreen(),
          SizedBox(height: 18),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: 350,
              height: 45,
              decoration: BoxDecoration(
                color: Color(0xffE4E7EC),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(width: 2, color: Color(0xffE4E7EC)),
                boxShadow: [BoxShadow(blurRadius: 4, color: Colors.blue)],
              ),
              alignment: Alignment.centerLeft,
              child: Icon(Icons.search),
            ),
          ),

          SizedBox(height: 18),
          CategoryExplorer(),
          SizedBox(height: 18),
          MostBorrowed(),
        ],
      ),
    );
  }
}
