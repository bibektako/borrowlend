import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/core/common/Notifications_view.dart';
import 'package:borrowlend/core/common/edit_profile_view.dart';
import 'package:borrowlend/core/config/theme/theme_cubit.dart';
import 'package:borrowlend/core/config/theme/theme_state.dart';
import 'package:borrowlend/features/auth/presentation/view/login_view.dart';
import 'package:borrowlend/features/borrow/presentation/view/borrow_request_page.dart';
import 'package:borrowlend/features/borrow/presentation/view/history.dart';
import 'package:borrowlend/features/borrow/presentation/view/ongoing_borrows_view.dart';
import 'package:borrowlend/features/profile/domain/entity/user_profile_entity.dart';
import 'package:borrowlend/features/profile/presentation/view_model/profile_event.dart';
import 'package:borrowlend/features/profile/presentation/view_model/profile_state.dart';
import 'package:borrowlend/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:borrowlend/features/settings/presentation/view/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              serviceLocator<ProfileViewModel>()..add(LoadUserProfile()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // The appearance is now 100% controlled by the `appBarTheme` in your
          // light and dark theme definitions.
          centerTitle: false,
          title: const Text("Profile"),
          actions: [
            // Theme toggle button
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                final isCurrentlyDark = themeState.themeMode == ThemeMode.dark;
                return IconButton(
                  tooltip: 'Toggle Theme',
                  icon: Icon(
                    isCurrentlyDark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                  ),
                  onPressed: () {
                    final newMode =
                        isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
                    context.read<ThemeCubit>().setTheme(newMode);
                  },
                );
              },
            ),
          ],
        ),
        // The body handles listening for state changes to trigger navigation
        body: const _ProfileViewBody(),
      ),
    );
  }
}

class _ProfileViewBody extends StatelessWidget {
  const _ProfileViewBody();

  @override
  Widget build(BuildContext context) {
    // Use BlocListener to handle "side effects" like navigation,
    // which should not be part of the builder method.
    return BlocListener<ProfileViewModel, ProfileState>(
      listener: (context, state) {
        // Listen for the specific state that indicates a successful logout.
        if (state.status == ProfileStatus.logoutSuccess) {
          // Navigate to the login screen and REMOVE all previous routes.
          // This prevents the user from pressing "back" to get into the app.
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginView()),
            (Route<dynamic> route) => false,
          );
        }
      },
      child: BlocBuilder<ProfileViewModel, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading &&
              state.userProfile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ProfileStatus.failure) {
            return Center(
              child: Text(state.errorMessage ?? "An error occurred."),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ProfileViewModel>().add(LoadUserProfile());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  _buildProfileHeader(context, state.userProfile),
                  const SizedBox(height: 32),
                  _buildProfileMenuList(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProfileEntity? user) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: theme.colorScheme.secondaryContainer,

            child: Icon(
              Icons.person,
              size: 35,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.username ?? "Loading...",
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(user?.email ?? "", style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuList(BuildContext context) {
    final viewModel = context.read<ProfileViewModel>();
    final theme = Theme.of(context);

    return Column(
      children: [
        _ProfileMenuItem(
          icon: Icons.person_outline,
          title: "My Profile",
          onTap: () {
            viewModel.add(
              NavigateToProfilePage(
                context: context,
                destination: const EditProfileView(),
              ),
            );
          },
        ),
        _ProfileMenuItem(
          icon: Icons.library_books_outlined,
          title: "Borrow Requests",
          onTap: () {
            final userId =
                context.read<ProfileViewModel>().state.userProfile?.id;
            if (userId != null) {
              viewModel.add(
                NavigateToProfilePage(
                  context: context,
                  destination: BorrowRequestsPage(currentUserId: userId),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Unable to load user ID")),
              );
            }
          },
        ),
        _ProfileMenuItem(
          icon: Icons.swap_horiz_outlined,
          title: "Ongoing Borrowings",
          onTap: () {
            final userId =
                context.read<ProfileViewModel>().state.userProfile?.id;
            if (userId != null) {
              viewModel.add(
                NavigateToProfilePage(
                  context: context,
                  destination: OngoingBorrowPage(currentUserId: userId),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Unable to load user ID")),
              );
            }
          },
        ),
        _ProfileMenuItem(
          icon: Icons.notifications_outlined,
          title: "Notifications",
          onTap: () {
            viewModel.add(
              NavigateToProfilePage(
                context: context,
                destination: const NotificationsView(),
              ),
            );
          },
        ),
        _ProfileMenuItem(
          icon: Icons.history_outlined,
          title: "Borrowing History",
          onTap: () {
            final userId =
                context.read<ProfileViewModel>().state.userProfile?.id;
            if (userId != null) {
              // Use the existing navigation event, just point to the new page
              viewModel.add(
                NavigateToProfilePage(
                  context: context,
                  destination: TransactionHistoryPage(currentUserId: userId),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Unable to load user ID")),
              );
            }
          },
        ),
        _ProfileMenuItem(
          icon: Icons.settings_outlined,
          title: "Settings",
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider.value(
                      value:
                          context
                              .read<
                                ThemeCubit
                              >(), // Pass the cubit from the current context
                      child: const SettingsView(),
                    ),
              ),
            );
          },
        ),
        const Divider(height: 32, indent: 24, endIndent: 24),
        _ProfileMenuItem(
          icon: Icons.logout,
          title: "Logout",
          textColor: theme.colorScheme.error,
          onTap: () {
            context.read<ProfileViewModel>().add(LogoutRequested());
          },
        ),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 4.0,
      ),
      leading: Icon(icon, color: textColor ?? Colors.black87, size: 26),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey.shade400,
      ),
      onTap: onTap,
    );
  }
}
