import 'package:borrowlend/features/dashboard/presentation/view_model/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardViewModel extends Cubit<DashboardState> {
  DashboardViewModel() : super(DashboardState.initial());

  void onTabTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  // void notification(BuildContext context) {
  //   Future.delayed(const Duration(seconds: 1), () async {
  //     if (context.mounted) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder:
  //               (context) => BlocProvider(
  //                 create: (context) => NotificationViewModel(),
  //                 child: NotificationView(),
  //               ),
  //         ),
  //       );
  //     }
  //   });
  // }
}
