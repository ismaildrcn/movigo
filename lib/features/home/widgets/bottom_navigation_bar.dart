import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movigo/app/router.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final GoRouterState state;
  const CustomBottomNavigationBar({super.key, required this.state});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  static final homeRoutes = [
    AppRoutes.home,
    AppRoutes.movies,
    AppRoutes.credits,
    AppRoutes.upcoming,
    AppRoutes.movie.split("/:").first,
    AppRoutes.reviews.split("/:").first,
  ];
  static const profileRoutes = [
    AppRoutes.profile,
    AppRoutes.login,
    AppRoutes.createAccount,
    AppRoutes.verifyEmail,
    AppRoutes.forgotPassword,
    AppRoutes.resetPassword,
    AppRoutes.markdownViewer,
    AppRoutes.userEdit,
  ];

  @override
  Widget build(BuildContext context) {
    final String location = widget.state.uri.toString();
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            navigationItem(
              context,
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: "Home",
              isActive: homeRoutes.any(
                (element) =>
                    location == element ||
                    location.startsWith(homeRoutes[4]) ||
                    location.startsWith(homeRoutes[5]),
              ),
              onTap: () => GoRouter.of(context).go(AppRoutes.home),
            ),
            navigationItem(
              context,
              icon: Icons.analytics_outlined,
              activeIcon: Icons.analytics_rounded,
              label: "Browser",
              isActive: location == AppRoutes.browser,
              onTap: () => GoRouter.of(context).go(AppRoutes.browser),
            ),
            navigationItem(
              context,
              icon: Icons.bookmark_outline,
              activeIcon: Icons.bookmark,
              label: "Wishlist",
              isActive: location == AppRoutes.wishlist,
              onTap: () => GoRouter.of(context).go(AppRoutes.wishlist),
            ),
            navigationItem(
              context,
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: "Profile",
              isActive: profileRoutes.any(
                (element) => location.startsWith(element),
              ),
              onTap: () => GoRouter.of(context).go(AppRoutes.profile),
            ),
          ],
        ),
      ),
    );
  }

  Widget navigationItem(
    context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: isActive
            ? BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface,
                borderRadius: BorderRadius.circular(10),
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: isActive
              ? Row(
                  spacing: 10,
                  children: [
                    Icon(
                      activeIcon,
                      size: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                )
              : Row(children: [Icon(icon, size: 24, color: Colors.grey[500])]),
        ),
      ),
    );
  }
}
