import 'dart:ffi';

import 'package:borrowlend/common/app_header.dart';
import 'package:borrowlend/common/bottom_nav_bar.dart';
import 'package:borrowlend/common/category_explorer.dart';
import 'package:borrowlend/common/most_borrowed.dart';
import 'package:borrowlend/common/slider_screen.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text("Home Page")),
    Center(child: Text("Explore Page")),
    Center(child: Text("Bookmarks Page")),
    Center(child: Text("Profile Page")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
