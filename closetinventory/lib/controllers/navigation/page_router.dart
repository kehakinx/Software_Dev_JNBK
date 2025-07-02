import 'package:closetinventory/views/authentication/login_page.dart';
import 'package:closetinventory/views/splash_page.dart';
import 'package:go_router/go_router.dart';
import 'package:closetinventory/controllers/utilities/constants.dart';

final GoRouter router = GoRouter(
  initialLocation:
      CONSTANTS.splashPage, // Use the constant from DirectoryRouter
  routes: [
    GoRoute(
      name: CONSTANTS.splashPage,
      path: CONSTANTS.splashPage,
      pageBuilder: (context, state) =>
          NoTransitionPage<void>(key: state.pageKey, child: const SplashPage()),
    ),
    GoRoute(
      name: CONSTANTS.loginPage,
      path: CONSTANTS.loginPage,
      pageBuilder: (context, state) =>
          NoTransitionPage<void>(key: state.pageKey, child: const LoginPage()),
    ),
  ],
);
