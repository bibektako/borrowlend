import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/app/theme/theme_data.dart';
import 'package:borrowlend/core/config/theme/theme_cubit.dart';
import 'package:borrowlend/core/config/theme/theme_state.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:borrowlend/features/auth/presentation/view_model/session/session_cubit.dart';
import 'package:borrowlend/features/borrow/presentation/view_model/borrow_items_view_model.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';
import 'package:borrowlend/features/splash/presentation/view/splashscreen_view.dart';
import 'package:borrowlend/features/splash/presentation/view_model/splashscreen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// App is the root widget responsible for providing all top-level Blocs and Cubits.
/// Its only child is the AppView, which builds the UI.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Use MultiBlocProvider to create and provide all global state managers.
    // Any widget below this in the tree can access these providers.
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<LoginViewModel>()),
        BlocProvider(create: (context) => serviceLocator<ItemViewModel>()),
        BlocProvider(create: (context) => serviceLocator<BorrowedItemsBloc>()),
        BlocProvider(create: (context) => serviceLocator<SessionCubit>()),
        BlocProvider(create: (context) => ThemeCubit()),
        
        // It's clean to provide the SplashscreenViewModel here if it's used at startup.
        BlocProvider(create: (context) => serviceLocator<SplashscreenViewModel>()),
      ],
      // The child is a separate widget that builds the MaterialApp.
      // This ensures the MaterialApp is built with a context that is a
      // descendant of MultiBlocProvider.
      child: const AppView(),
    );
  }
}

/// AppView is responsible for building the MaterialApp and consuming the theme state.
class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    // Use BlocBuilder to get the current theme state from the ThemeCubit.
    // This will rebuild the MaterialApp whenever the theme changes.
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
        

          debugShowCheckedModeBanner: false,
          
          // Apply the light, dark, and current theme mode from the ThemeCubit's state.
          // This now works because the context for this builder is below the provider.
          theme: getApplicationTheme(),
          darkTheme: getDarkApplicationTheme(), // Make sure this function exists in your theme file
          themeMode: themeState.themeMode,

          // The home widget. It can now access any of the globally provided Blocs.
          home: const SplashscreenView(),
        );
      },
    );
  }
}