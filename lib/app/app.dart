import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/app/theme/theme_data.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:borrowlend/features/borrow/presentation/view_model/borrow_items_view_model.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';

import 'package:borrowlend/features/splash/presentation/view/splashscreen_view.dart';
import 'package:borrowlend/features/splash/presentation/view_model/splashscreen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginViewModel>(
          create: (context) => serviceLocator<LoginViewModel>(),
        ),

        BlocProvider<ItemViewModel>(
          create: (context) => serviceLocator<ItemViewModel>(),
        ),
        BlocProvider<BorrowedItemsBloc>(
          create: (context) => serviceLocator<BorrowedItemsBloc>(),
        ),
        
      ],

    child:  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider.value(
        value: serviceLocator<SplashscreenViewModel>(),
        child: SplashscreenView(),
      ),
      theme: getApplicationTheme(),)
    );
  }
}
