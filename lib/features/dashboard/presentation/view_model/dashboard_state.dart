import 'package:borrowlend/features/items/presentation/view/bookmarked_items.dart';
import 'package:borrowlend/features/items/presentation/view/my_items_view.dart';
import 'package:borrowlend/features/profile/presentation/view/profile_view.dart';
import 'package:borrowlend/features/home/presentation/view/home_page_view.dart';
import 'package:flutter/widgets.dart';

class DashboardState {
  final int selectedIndex;
  final List<Widget> views;
  const DashboardState({required this.selectedIndex, required this.views});

  static DashboardState initial() {
    return DashboardState(
      selectedIndex: 0,
      views: [
        HomePageView(),
        MyItemsView(),
        BookmarksView(),
        ProfileView(),
      ],
    );
  }

  DashboardState copyWith({int? selectedIndex}) {
    return DashboardState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views,
    );
  }
}
