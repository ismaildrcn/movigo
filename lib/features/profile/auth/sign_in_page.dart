import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movigo/app/router.dart';
import 'package:movigo/app/topbar.dart';
import 'package:movigo/data/datasources/remote.dart';
import 'package:movigo/data/services/auth_service.dart';
import 'package:movigo/features/home/widgets/auth_common_footer.dart';
import 'package:movigo/features/profile/utils/auth_provider.dart';
import 'package:movigo/features/profile/utils/auth_response.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  bool isValidEmail = false;
  bool isEmailTouched = false;
  bool isPasswordVisible = false;
  bool isRememberMeChecked = false;

  String? _email;
  String? _password;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {
        isEmailTouched = true;
        isValidEmail = EmailValidator.validate(emailController.text);
      });
    });
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TopBar(title: "Sign In", showBackButton: false),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withAlpha(128),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
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
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.error.withAlpha(128),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.error.withAlpha(128),
                            ),
                          ),
                        ),
                        onSaved: (newValue) {
                          _email = newValue;
                        },
                      ),
                      SizedBox(height: 16),
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
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withAlpha(128),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondary.withAlpha(75),
                            ),
                          ),
                        ),
                        onSaved: (newValue) {
                          _password = newValue;
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                              Text("Remember me"),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text("Forgot password?"),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => submitForm(context),
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
                        child: Text("Login"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
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
                        "New to Movigo?",
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
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.push(AppRoutes.createAccount);
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
                    "Create Account",
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(128),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                CommonFooterLinks(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<AnimatedSnackBar?> submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // Call the signInUser method from AuthService
      _authService.signInUser(_email!, _password!).then((response) {
        if (response != null) {
          if (response.statusCode == 200) {
            Provider.of<AuthProvider>(
              context,
              listen: false,
            ).login(AuthResponse.fromJson(response.data));
            ApiService.addTokenInterceptor();
          } else {
            // Hata durumunda snackbar göster
            AnimatedSnackBar.material(
              response.data["message"] ?? "An error occurred",
              type: (response.statusCode == 404 || response.statusCode == 401)
                  ? AnimatedSnackBarType.error
                  : AnimatedSnackBarType.warning,
            ).show(context);
          }
        } else {
          // Handle login error
        }
      });
    }
    return null;
  }
}
