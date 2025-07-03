import 'package:borrowlend/view/explore_view.dart';
import 'package:borrowlend/features/home/presentation/view/home_page_view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardState {
  final int selectedIndex;
  final List<Widget> views;
  const DashboardState ({required this.selectedIndex, required this.views});

  static DashboardState initial(){
    return DashboardState(selectedIndex: 0, views: [
      HomePageView(),
      Center(child: Text("Explore Page")),
      Center(child: Text("Bookmarks Page")),
      Center(child: Text("Profile Page")),
      // BlocProvider(create: (context) => ExploreViewModel(), child: ExploreView(),)
    ],);
  }
  DashboardState copyWith({int? selectedIndex}){
    return DashboardState(selectedIndex: selectedIndex ?? this.selectedIndex, views: views );
  }
}