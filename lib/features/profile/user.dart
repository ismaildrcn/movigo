import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movigo/app/router.dart';
import 'package:movigo/app/topbar.dart';
import 'package:movigo/data/model/user/user_model.dart';
import 'package:movigo/data/services/user_service.dart';
import 'package:movigo/features/profile/utils/auth_provider.dart';
import 'package:movigo/features/profile/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class UserEditPage extends StatefulWidget {
  const UserEditPage({super.key});

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  UserModel? user;
  AuthProvider authProvider = AuthProvider();
  UserService userService = UserService();

  final TextEditingController _userFullNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userPhoneNumberController =
      TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  GenderEnum? selectedGender;
  @override
  void initState() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    user = authProvider.user!;
    _userFullNameController.text = user!.fullName;
    _userEmailController.text = user!.email;
    _userPhoneNumberController.text = user!.phone ?? '';
    _birthDateController.text = user!.birthdate ?? '';
    selectedGender = user!.gender!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopBar(
                title: "Edit Profile",
                callback: () => context.push(AppRoutes.profile),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    userVerifiedContent(),
                    Text(
                      "Personal",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.headlineLarge!.color,
                      ),
                    ),
                    TextField(
                      controller: _userFullNameController,
                      decoration: buildInputDecoration(hintText: "Full Name"),
                      style: TextStyle(fontSize: 14),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 1,
                            child: GenderCard(
                              selectedGender: selectedGender!,
                              onGenderChanged: (gender) {
                                setState(() {
                                  selectedGender = gender;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: DatePickerField(
                              controller: _birthDateController,
                              decoration: buildInputDecoration(
                                hintText: "Birth Date",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      "Contact",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.headlineLarge!.color,
                      ),
                    ),
                    TextField(
                      controller: _userEmailController,
                      decoration: buildInputDecoration(hintText: "Email"),
                      style: TextStyle(fontSize: 14),
                    ),
                    TextField(
                      controller: _userPhoneNumberController,
                      decoration: buildInputDecoration(
                        hintText: "+90 *** *** ****",
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        Response? response = await userService
                            .updateUserDetails({
                              'id': user!.id!,
                              'full_name': _userFullNameController.text,
                              'email': _userEmailController.text,
                              'phone': _userPhoneNumberController.text == ''
                                  ? null
                                  : _userPhoneNumberController.text,
                              'gender': selectedGender
                                  .toString()
                                  .split('.')
                                  .last,
                              'birthdate': _birthDateController.text,
                            });
                        if (!mounted) return;

                        if (response != null && response.statusCode == 200) {
                          Provider.of<AuthProvider>(
                            context,
                            listen: false,
                          ).updateUser(
                            UserModel.fromJson(response.data['data']),
                          );

                          AnimatedSnackBar.material(
                            "Profile updated successfully",
                            type: AnimatedSnackBarType.success,
                          ).show(context);

                          // Snackbar gösterildikten sonra navigate
                          Future.delayed(Duration(milliseconds: 100), () {
                            if (mounted) context.push(AppRoutes.profile);
                          });
                        } else {
                          AnimatedSnackBar.material(
                            response?.data["message"] ?? "An error occurred",
                            type:
                                (response?.statusCode == 404 ||
                                    response?.statusCode == 401)
                                ? AnimatedSnackBarType.error
                                : AnimatedSnackBarType.warning,
                          ).show(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                        textStyle: TextStyle(fontSize: 14),
                      ),
                      child: Text('Save Changes'),
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

  Container userVerifiedContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (user?.isVerified ?? false)
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (user?.isVerified ?? false) ? Colors.green : Colors.orange,
        ),
      ),
      child: Row(
        children: [
          Icon(
            (user?.isVerified ?? false) ? Icons.verified_user : Icons.gpp_maybe,
            color: (user?.isVerified ?? false) ? Colors.green : Colors.orange,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (user?.isVerified ?? false)
                      ? "Verified Account"
                      : "Unverified Account",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: (user?.isVerified ?? false)
                        ? Colors.green[700]
                        : Colors.orange[800],
                  ),
                ),
                if (!(user?.isVerified ?? false)) ...[
                  const SizedBox(height: 4),
                  Text(
                    "Please verify your email address.",
                    style: TextStyle(fontSize: 13, color: Colors.orange[800]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration buildInputDecoration({String hintText = ''}) {
    return InputDecoration(
      hintText: hintText,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.onSecondary.withAlpha(128),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary.withAlpha(128),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
