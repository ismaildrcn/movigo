import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movigo/data/model/movie/credits_model.dart';
import 'package:movigo/data/model/movie/movie_model.dart';
import 'package:movigo/features/home/review_page.dart';
import 'package:movigo/features/home/upcoming_page.dart';
import 'package:movigo/features/home/widgets/bottom_navigation_bar.dart';
import 'package:movigo/features/onboarding/onboarding_first.dart';
import 'package:movigo/features/onboarding/onboarding_second.dart';
import 'package:movigo/features/onboarding/onboarding_third.dart';
import 'package:movigo/features/profile/auth/create_account_page.dart';
import 'package:movigo/features/profile/auth/forgot_password_page.dart';
import 'package:movigo/features/profile/auth/reset_password_page.dart';
import 'package:movigo/features/profile/auth/sign_in_page.dart';
import 'package:movigo/features/profile/auth/verify_email.dart';
import 'package:movigo/features/home/credits_page.dart';
import 'package:movigo/features/home/movies_page.dart';
import 'package:movigo/features/home/movie_page.dart';
import 'package:movigo/features/profile/markdown_viewer.dart';
import 'package:movigo/features/browser/browser.dart';
import 'package:movigo/features/profile/user.dart';
import 'package:movigo/features/profile/utils/auth_provider.dart';
import 'package:movigo/features/wishlist/wishlist_page.dart';
import 'package:movigo/features/home/home.dart';
import 'package:movigo/features/profile/profile.dart';

class AppRoutes {
  AppRoutes._();
  static const String home = '/';
  static const String movies = "/movies";
  static const String movie = "/movie/:id";
  static const String credits = "/credits";
  static const String browser = '/browser';
  static const String discover = '/discover';
  static const String profile = '/profile';
  static const String login = '/login';
  static const String createAccount = '/create-account';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String markdownViewer = '/markdown-viewer';
  static const String reviews = '/reviews/:id';
  static const String upcoming = '/upcoming';
  static const String onboardingFirst = '/onboarding-first';
  static const String onboardingSecond = '/onboarding-second';
  static const String onboardingThird = '/onboarding-third';
  static const String wishlist = '/wishlist';
  static const String userEdit = '/user-edit';
}

class AppRouter {
  final AuthProvider authProvider;

  AppRouter(this.authProvider);

  GoRouter get router => GoRouter(
    refreshListenable: authProvider,
    redirect: _guardRoutes,
    routes: _routes,
  );

  String? _guardRoutes(BuildContext context, GoRouterState state) {
    final isLoggedIn = authProvider.isAuthenticated;
    final currentPath = state.uri.path;

    // Eğer kullanıcı giriş yapmamışsa ve onboarding sayfalarında değilse
    if (!isLoggedIn) {
      if (currentPath != AppRoutes.onboardingFirst &&
          currentPath != AppRoutes.onboardingSecond &&
          currentPath != AppRoutes.onboardingThird &&
          currentPath != AppRoutes.createAccount &&
          currentPath != AppRoutes.markdownViewer &&
          currentPath != AppRoutes.login) {
        return AppRoutes.onboardingFirst;
      }
    }

    // Eğer kullanıcı giriş yapmışsa
    if (isLoggedIn &&
        (currentPath == AppRoutes.onboardingFirst ||
            currentPath == AppRoutes.onboardingSecond ||
            currentPath == AppRoutes.onboardingThird ||
            currentPath == AppRoutes.login)) {
      return AppRoutes.home;
    }

    return null;
  }

  List<RouteBase> get _routes => [
    ShellRoute(
      builder: (context, state, child) {
        final hideBottomNavigation = [
          AppRoutes.onboardingFirst,
          AppRoutes.onboardingSecond,
          AppRoutes.onboardingThird,
          AppRoutes.login,
          AppRoutes.createAccount,
          AppRoutes.verifyEmail,
          AppRoutes.forgotPassword,
          AppRoutes.resetPassword,
        ];

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          bottomNavigationBar: hideBottomNavigation.contains(state.uri.path)
              ? null
              : CustomBottomNavigationBar(state: state),
          body: child,
        );
      },
      routes: [
        GoRoute(
          name: "home",
          path: AppRoutes.home,
          pageBuilder: (context, state) {
            return const MaterialPage(child: HomePage());
          },
        ),
        GoRoute(
          name: "movies",
          path: AppRoutes.movies,
          pageBuilder: (context, state) {
            final Map<String, dynamic> extra =
                state.extra as Map<String, dynamic>;
            final List<MovieModel> allMovies =
                extra['allMovies'] as List<MovieModel>;
            final String title = extra['title'] as String;
            return MaterialPage(
              child: MoviesPage(allMovies: allMovies, title: title),
            );
          },
        ),
        GoRoute(
          name: "movie",
          path: AppRoutes.movie,
          pageBuilder: (context, state) {
            final movieId = state.pathParameters['id']!;
            final bool hasVideo = state.extra as bool? ?? false;
            return MaterialPage(
              child: MoviePage(movieId: int.parse(movieId), hasVideo: hasVideo),
            );
          },
        ),
        GoRoute(
          name: "credits",
          path: AppRoutes.credits,
          pageBuilder: (context, state) {
            final Credits credits = state.extra as Credits;
            return MaterialPage(child: CreditsPage(credits: credits));
          },
        ),
        GoRoute(
          name: "browser",
          path: AppRoutes.browser,
          pageBuilder: (context, state) {
            return const MaterialPage(child: BrowserPage());
          },
        ),
        GoRoute(
          name: "profile",
          path: AppRoutes.profile,
          pageBuilder: (context, state) {
            return const MaterialPage(child: ProfilePage());
          },
        ),
        GoRoute(
          name: "login",
          path: AppRoutes.login,
          pageBuilder: (context, state) {
            return const MaterialPage(child: SignInPage());
          },
        ),
        GoRoute(
          name: "crate-account",
          path: AppRoutes.createAccount,
          pageBuilder: (context, state) {
            return const MaterialPage(child: CreateAccountPage());
          },
        ),
        GoRoute(
          name: "verify-email",
          path: AppRoutes.verifyEmail,
          pageBuilder: (context, state) {
            return const MaterialPage(child: VerifyEmailPage());
          },
        ),
        GoRoute(
          name: "forgot-password",
          path: AppRoutes.forgotPassword,
          pageBuilder: (context, state) {
            return const MaterialPage(child: ForgotPasswordPage());
          },
        ),
        GoRoute(
          name: "reset-password",
          path: AppRoutes.resetPassword,
          pageBuilder: (context, state) {
            return const MaterialPage(child: ResetPasswordPage());
          },
        ),
        GoRoute(
          name: "markdown-viewer",
          path: AppRoutes.markdownViewer,
          pageBuilder: (context, state) {
            final List markdownContent = state.extra as List;
            return MaterialPage(
              child: MarkdownViewer(
                markdownAssetPath: markdownContent[0],
                title: markdownContent[1],
              ),
            );
          },
        ),
        GoRoute(
          name: "reviews",
          path: AppRoutes.reviews,
          pageBuilder: (context, state) {
            final movieId = state.pathParameters['id']!;
            return MaterialPage(child: ReviewPage(id: int.parse(movieId)));
          },
        ),
        GoRoute(
          name: "upcoming",
          path: AppRoutes.upcoming,
          pageBuilder: (context, state) {
            final List<MovieModel> allMovies = state.extra as List<MovieModel>;
            return MaterialPage(child: UpcomingPage(movies: allMovies));
          },
        ),
        GoRoute(
          name: "onboarding-first",
          path: AppRoutes.onboardingFirst,
          pageBuilder: (context, state) {
            return MaterialPage(child: OnboardingFirst());
          },
        ),
        GoRoute(
          name: "onboarding-second",
          path: AppRoutes.onboardingSecond,
          pageBuilder: (context, state) {
            return MaterialPage(child: OnboardingSecond());
          },
        ),
        GoRoute(
          name: "onboarding-third",
          path: AppRoutes.onboardingThird,
          pageBuilder: (context, state) {
            return MaterialPage(child: OnboardingThird());
          },
        ),
        GoRoute(
          name: "wishlist",
          path: AppRoutes.wishlist,
          pageBuilder: (context, state) {
            return MaterialPage(child: WishlistPage());
          },
        ),
        GoRoute(
          name: "userEdit",
          path: AppRoutes.userEdit,
          pageBuilder: (context, state) {
            return MaterialPage(child: UserEditPage());
          },
        ),
      ],
    ),
  ];
}
