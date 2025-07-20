import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/core/common/app_header.dart';
import 'package:borrowlend/core/common/bottom_nav_bar.dart';
import 'package:borrowlend/features/category/presentation/view_model/category_event.dart';
import 'package:borrowlend/features/category/presentation/view_model/category_viewmodel.dart';
import 'package:borrowlend/features/dashboard/presentation/view_model/dashboard_state.dart';
import 'package:borrowlend/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_event.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';
import 'package:borrowlend/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DashboardViewModel(),
        ),
        BlocProvider.value(
          value: serviceLocator<ItemViewModel>()..add(LoadAllItemsEvent()),
        ),
        BlocProvider(
          create: (context) => serviceLocator<CategoryBloc>()..add(FetchCategories()),
        ),
        BlocProvider.value(
          value: serviceLocator<ProfileViewModel>(),
        ),
      ],
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
                final itemViewModel = context.read<ItemViewModel>();
                if (index == 1) { // My Items tab
                  itemViewModel.add(LoadMyItemsEvent());
                } else if (index == 2) { // Bookmarks tab
                  itemViewModel.add(LoadBookmarkedItemsEvent());
                }
                
                context.read<DashboardViewModel>().onTabTapped(index);
              },
            );
          },
        ),
      ),
    );
  }
}