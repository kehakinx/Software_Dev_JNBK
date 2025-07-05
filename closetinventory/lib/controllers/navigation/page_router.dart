import 'package:closetinventory/models/item_dataobj.dart';
import 'package:closetinventory/views/authentication/login_page.dart';
import 'package:closetinventory/views/home_page.dart';
import 'package:closetinventory/views/items/addnewitem_page.dart';
import 'package:closetinventory/views/items/edititem_page.dart';
import 'package:closetinventory/views/items/viewallitems_page.dart';
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
    GoRoute(
      name: CONSTANTS.homePage,
      path: CONSTANTS.homePage,
      pageBuilder: (context, state) =>
          NoTransitionPage<void>(key: state.pageKey, child: const HomePage()),
    ),
    GoRoute(
      name: CONSTANTS.addItemPage,
      path: CONSTANTS.addItemPage,
      pageBuilder: (context, state) =>
          NoTransitionPage<void>(key: state.pageKey, child: const AddNewItemPage()),
    ),
    GoRoute(
      name: CONSTANTS.viewallItemsPage,
      path: CONSTANTS.viewallItemsPage,
      pageBuilder: (context, state) =>
          NoTransitionPage<void>(key: state.pageKey, child: const ViewallitemsPage()),
    ),
    GoRoute(
      name: CONSTANTS.viewItemPage,
      path: CONSTANTS.viewItemPage,
      pageBuilder: (context, state) =>
          NoTransitionPage<void>(key: state.pageKey, child: EditItemPage(closetItem: state.extra as Item,)),
    ),
  ],
);
