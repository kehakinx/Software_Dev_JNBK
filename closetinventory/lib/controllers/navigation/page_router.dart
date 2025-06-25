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
  ],
);
