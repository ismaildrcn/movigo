import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_app/app/router.dart';
import 'package:imdb_app/app/topbar.dart';
import 'package:imdb_app/data/model/user/user_model.dart';
import 'package:imdb_app/data/services/auth_service.dart';
import 'package:imdb_app/features/home/widgets/auth_common_footer.dart';
import 'package:imdb_app/features/profile/widgets/common_widgets.dart';
import 'package:intl/intl.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  GenderEnum? selectedGender;

  bool isValidEmail = false;
  bool isEmailTouched = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isRememberMeChecked = false;

  String? fullName;
  String? email;
  String? password;

  @override
  void initState() {
    super.initState();
    selectedGender = GenderEnum.male;
    emailController.addListener(() {
      setState(() {
        isEmailTouched = true;
        isValidEmail = EmailValidator.validate(emailController.text);
      });
    });
  }

  void createAccount(BuildContext context) async {
    UserModel user;
    if (_formKey.currentState!.validate()) {
      // Save the form data
      _formKey.currentState!.save();

      DateFormat inputFormat = DateFormat('d/M/yyyy');
      DateTime date = inputFormat.parse(birthDateController.text);

      String isoDate = DateFormat('yyyy-MM-dd').format(date);
      user = UserModel(
        fullName: fullName!,
        email: email!,
        password: password!,
        role: 'user',
        avatar: null,
        phone: null,
        birthdate: isoDate,
        gender: selectedGender,
      );
      await _authService.createUser(user).then((result) {
        if (result == null || result.statusCode == 500) {
          debugPrint("Error creating user");
          AnimatedSnackBar.material(
            'Error creating user',
            type: AnimatedSnackBarType.error,
          ).show(context);
          return;
        }

        if (result.statusCode == 200) {
          context.push(AppRoutes.login);
        } else if (result.statusCode == 400) {
          AnimatedSnackBar.material(
            result.data["message"],
            type: AnimatedSnackBarType.warning,
          ).show(context);
        }
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TopBar(title: "Sign Up", showBackButton: false),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  spacing: 16,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        spacing: 16,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Full Name",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                borderSide: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withAlpha(128),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                borderSide: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary.withAlpha(75),
                                ),
                              ),
                            ),
                            onSaved: (newValue) {
                              fullName = newValue!;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                borderSide: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withAlpha(128),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                borderSide: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary.withAlpha(75),
                                ),
                              ),
                              errorText: !isValidEmail && isEmailTouched
                                  ? "Invalid email"
                                  : null,
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                borderSide: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.error.withAlpha(128),
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                borderSide: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.error.withAlpha(128),
                                ),
                              ),
                            ),
                            onSaved: (newValue) {
                              email = newValue!;
                            },
                          ),
                          TextFormField(
                            obscureText: !isPasswordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            controller: passwordController,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                child: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withAlpha(128),
                                ),
                              ),
                              labelText: "Password",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                borderSide: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withAlpha(128),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                borderSide: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary.withAlpha(75),
                                ),
                              ),
                            ),
                            onSaved: (newValue) {
                              password = newValue!;
                            },
                          ),
                          TextFormField(
                            obscureText: !isConfirmPasswordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isConfirmPasswordVisible =
                                        !isConfirmPasswordVisible;
                                  });
                                },
                                child: Icon(
                                  isConfirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withAlpha(128),
                                ),
                              ),
                              labelText: "Confirm Password",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                borderSide: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withAlpha(128),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                borderSide: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary.withAlpha(75),
                                ),
                              ),
                            ),
                          ),

                          Row(
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
                                  controller: birthDateController,
                                  hintText: "Birth Date",
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Checkbox(
                                value: isRememberMeChecked,
                                checkColor: Theme.of(
                                  context,
                                ).colorScheme.surface,
                                activeColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    isRememberMeChecked = value ?? false;
                                  });
                                },
                              ),
                              const Text("Remember me"),
                            ],
                          ),

                          ElevatedButton(
                            onPressed: () => createAccount(context),
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: Size(double.infinity, 40),
                            ),
                            child: const Text("Create Account"),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            indent: 5,
                            endIndent: 10,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withAlpha(68),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            indent: 10,
                            endIndent: 5,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withAlpha(68),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.push(AppRoutes.login);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withAlpha(128),
                            width: 2.0,
                          ),
                        ),
                        minimumSize: Size(double.infinity, 40),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withAlpha(128),
                        ),
                      ),
                    ),
                    CommonFooterLinks(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<AnimatedSnackBar?> submitForm(BuildContext context) async {
    UserModel user;
    if (_formKey.currentState!.validate()) {
      // Save the form data
      _formKey.currentState!.save();
      user = UserModel(
        fullName: fullName!,
        email: email!,
        password: password!,
        role: 'user',
        avatar: null,
        phone: null,
      );
      debugPrint("Create Account button pressed");
      await _authService.createUser(user).then((result) {
        if (result == null || result.statusCode == 500) {
          debugPrint("Error creating user");
          return AnimatedSnackBar.material(
            'Error creating user',
            type: AnimatedSnackBarType.error,
          ).show(context);
        }

        if (result.statusCode == 200) {
          AnimatedSnackBar.material(
            result.data["message"],
            type: AnimatedSnackBarType.info,
          ).show(context);
          context.push(AppRoutes.login);
          return;
        } else if (result.statusCode == 400) {
          return AnimatedSnackBar.material(
            result.data["message"],
            type: AnimatedSnackBarType.warning,
          ).show(context);
        }
      });
    }
    return null;
  }
}
