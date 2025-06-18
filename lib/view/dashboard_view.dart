import 'package:borrowlend/core/common/app_header.dart';
import 'package:borrowlend/core/common/bottom_nav_bar.dart';
import 'package:borrowlend/view/home_page_view.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePageView(),
    Center(child: Text("Explore Page")),
    Center(child: Text("Bookmarks Page")),
    Center(child: Text("Profile Page")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Adjust height as needed
        child: SafeArea(
          // Optional: Avoid status bar overlap
          child: AppHeader(),
        ),
      ),

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
