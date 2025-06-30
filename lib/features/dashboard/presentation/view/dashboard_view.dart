import 'package:borrowlend/core/common/app_header.dart';
import 'package:borrowlend/core/common/bottom_nav_bar.dart';
import 'package:borrowlend/features/dashboard/presentation/view_model/dashboard_state.dart';
import 'package:borrowlend/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardViewModel(),
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: SafeArea(child: AppHeader()),
        ),

        body: BlocBuilder<DashboardViewModel, DashboardState>(
          builder: (context, state) {
            return IndexedStack(
              index: state.selectedIndex,
              children: state.views,
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<DashboardViewModel, DashboardState>(
          builder: (context, state) {
            return BottomNavBar(
              currentIndex: state.selectedIndex,
              onTap: (index) {
                context.read<DashboardViewModel>().onTabTapped(index);
              },
            );
          },
        ),
      ),
    );
  }
}
