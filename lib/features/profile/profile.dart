import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movigo/app/router.dart';
import 'package:movigo/app/theme_manager.dart';
import 'package:movigo/app/topbar.dart';
import 'package:movigo/data/model/user/user_model.dart';
import 'package:movigo/features/profile/utils/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    currentUser = authProvider.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopBar(title: "Profile", showBackButton: false),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  spacing: 20,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 86,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: BoxBorder.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withAlpha(50),
                          width: 2,
                          style: BorderStyle.solid,
                          strokeAlign: 0.7,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(
                              64,
                            ), // Gölge rengi ve opaklık
                            blurRadius: 5, // Gölge yumuşaklığı
                            spreadRadius: 1, // Gölge yayılması
                            offset: Offset(0, 2), // Gölge pozisyonu (x, y)
                          ),
                        ],
                      ),
                      child: Row(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.transparent,
                            backgroundImage: currentUser?.avatar != null
                                ? NetworkImage(currentUser!.avatar!)
                                : AssetImage("assets/img/popcorn.png"),
                          ),
                          Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Welcome",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.labelSmall!.color,
                                ),
                              ),
                              Text(
                                currentUser?.fullName ?? "Guest",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Provider.of<AuthProvider>(
                                context,
                                listen: false,
                              ).logout();
                            },
                            child: Icon(
                              Icons.logout,
                              color: Theme.of(context).colorScheme.primary,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Account Area
                    profileAccountContent(context),

                    // General Area
                    profileGeneralContent(context),

                    // More Area
                    profileMoreContent(context),

                    OutlinedButton(
                      onPressed: () {
                        Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        ).logout();
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: Size(double.infinity, 56),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1,
                          style: BorderStyle.solid,
                          strokeAlign: 0.7,
                        ),
                      ),
                      child: Text("Log Out"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileAccountContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: BoxBorder.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(20),
          width: 2,
          style: BorderStyle.solid,
          strokeAlign: 0.7,
        ),
      ),
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Account",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 8),
          subProfileContent(
            context,
            title: "User Profile",
            icon: Icons.person_pin_rounded,
            onTap: () {
              debugPrint("User Profile Tapped");
              context.push(AppRoutes.userEdit);
            },
            iconColor: Theme.of(context).colorScheme.primary,
          ),
          Divider(
            color: Theme.of(context).colorScheme.primary.withAlpha(20),
            thickness: 1.5,
          ),
          subProfileContent(
            context,
            title: "Change Password",
            icon: Icons.lock,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget profileGeneralContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: BoxBorder.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(20),
          width: 2,
          style: BorderStyle.solid,
          strokeAlign: 0.7,
        ),
      ),
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "General",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 8),
          subProfileContent(
            context,
            title: "Change Theme",
            icon: Icons.view_carousel_rounded,
            onTap: () {
              final themeManager = Provider.of<ThemeManager>(
                context,
                listen: false,
              );
              themeManager.toggleTheme(
                themeManager.themeMode != ThemeMode.dark,
              );
            },
          ),
          Divider(
            color: Theme.of(context).colorScheme.primary.withAlpha(20),
            thickness: 1.5,
          ),
          subProfileContent(
            context,
            title: "Notifications",
            icon: Icons.notifications,
            onTap: () {},
          ),
          Divider(
            color: Theme.of(context).colorScheme.primary.withAlpha(20),
            thickness: 1.5,
          ),
          subProfileContent(
            context,
            title: "Language",
            icon: Icons.language,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget profileMoreContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: BoxBorder.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(20),
          width: 2,
          style: BorderStyle.solid,
          strokeAlign: 0.7,
        ),
      ),
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "More",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 8),
          subProfileContent(
            context,
            title: "Conditions of Use",
            icon: Icons.notifications,
            onTap: () => context.push(
              AppRoutes.markdownViewer,
              extra: [
                'assets/markdown/legal/conditions_of_use.md',
                'Conditions of Use',
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.primary.withAlpha(20),
            thickness: 1.5,
          ),
          subProfileContent(
            context,
            title: "Privay Notes",
            icon: Icons.privacy_tip,
            onTap: () => context.push(
              AppRoutes.markdownViewer,
              extra: [
                'assets/markdown/legal/privacy_notes.md',
                'Privacy Notes',
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.primary.withAlpha(20),
            thickness: 1.5,
          ),
          subProfileContent(
            context,
            title: "Help  & Feedback",
            icon: Icons.help,
            onTap: () {},
          ),
          Divider(
            color: Theme.of(context).colorScheme.primary.withAlpha(20),
            thickness: 1.5,
          ),
          subProfileContent(
            context,
            title: "About Us",
            icon: Icons.info,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget subProfileContent(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor = Colors.grey,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        spacing: 20,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: iconColor!.withAlpha(32),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 24, color: iconColor),
          ),
          Text(title, style: TextStyle(fontSize: 16)),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, color: iconColor),
        ],
      ),
    );
  }
}
