import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/core/common/Notifications_view.dart';
import 'package:borrowlend/core/common/edit_profile_view.dart';
import 'package:borrowlend/features/auth/presentation/view/login_view.dart';
import 'package:borrowlend/features/borrow/presentation/view/borrow_request_page.dart';
import 'package:borrowlend/features/borrow/presentation/view/ongoing_borrows_view.dart';
import 'package:borrowlend/features/profile/domain/entity/user_profile_entity.dart';
import 'package:borrowlend/features/profile/presentation/view_model/profile_event.dart';
import 'package:borrowlend/features/profile/presentation/view_model/profile_state.dart';
import 'package:borrowlend/features/profile/presentation/view_model/profile_view_model.dart';
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
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          title: const Text(
            "Profile",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
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
                  _buildProfileHeader(state.userProfile),
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

  Widget _buildProfileHeader(UserProfileEntity? user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey.shade200,
            child: const Icon(Icons.person, size: 35, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.username ?? "Loading...",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? "",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuList(BuildContext context) {
    final viewModel = context.read<ProfileViewModel>();

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
            // Logic for navigating to sub-pages remains the same
          },
        ),
        _ProfileMenuItem(
          icon: Icons.swap_horiz_outlined,
          title: "Ongoing Borrowings",
          onTap: () {
            // Logic for navigating to sub-pages remains the same
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
        const Divider(height: 32, indent: 24, endIndent: 24),
        _ProfileMenuItem(
          icon: Icons.logout,
          title: "Logout",
          textColor: Colors.red,
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
