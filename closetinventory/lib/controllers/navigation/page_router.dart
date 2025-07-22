import 'package:closetinventory/models/item_dataobj.dart';
import 'package:closetinventory/models/outfit_dataobj.dart';
import 'package:closetinventory/views/authentication/login_page.dart';
import 'package:closetinventory/views/authentication/register_page.dart';
import 'package:closetinventory/views/home_page.dart';
import 'package:closetinventory/views/items/addnewitem_page.dart';
import 'package:closetinventory/views/items/edititem_page.dart';
import 'package:closetinventory/views/items/viewallitems_page.dart';
import 'package:closetinventory/views/items/search_results.dart';
import 'package:closetinventory/views/outfits/addnewoutfit_page.dart';
import 'package:closetinventory/views/outfits/editoutfit_page.dart';
import 'package:closetinventory/views/outfits/viewoutfits_page.dart';
import 'package:closetinventory/views/profile_page.dart';
import 'package:closetinventory/views/wishlist/wishlist_page.dart';
import 'package:closetinventory/views/splash_page.dart';
import 'package:go_router/go_router.dart';
import 'package:closetinventory/controllers/utilities/constants.dart';

final GoRouter router = GoRouter(
  initialLocation: CONSTANTS.splashPage,
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
      name: CONSTANTS.registerPage,
      path: CONSTANTS.registerPage,
      pageBuilder: (context, state) =>
          NoTransitionPage<void>(key: state.pageKey, child: const RegisterPage()),
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
      name: CONSTANTS.addOutfitPage,
      path: CONSTANTS.addOutfitPage,
      pageBuilder: (context, state) =>
          NoTransitionPage<void>(key: state.pageKey, child: const AddNewOutfitPage()),
    ),
    GoRoute(
      name: CONSTANTS.viewallItemsPage,
      path: CONSTANTS.viewallItemsPage,
      pageBuilder: (context, state) =>
          NoTransitionPage<void>(key: state.pageKey, child: ViewallitemsPage(
            unworn: state.extra == "unWorn",
            declutter: state.extra == "declutter",
          )),
    ),
    GoRoute(
      name: CONSTANTS.viewallOutfitsPage,
      path: CONSTANTS.viewallOutfitsPage,
      pageBuilder: (context, state) =>
          NoTransitionPage<void>(key: state.pageKey, child: const ViewalloutfitsPage()),
    ),
    GoRoute(
      name: CONSTANTS.viewItemPage,
      path: CONSTANTS.viewItemPage,
      pageBuilder: (context, state) =>
          NoTransitionPage<void>(key: state.pageKey, child: EditItemPage(closetItem: state.extra as Item,)),
    ),
    GoRoute(
      name: CONSTANTS.viewOutfitPage,
      path: CONSTANTS.viewOutfitPage,
      pageBuilder: (context, state) =>
          NoTransitionPage<void>(key: state.pageKey, child: EditOutfitPage(closetOutfit: state.extra as Outfit,)),
    ),
    GoRoute(
      name: CONSTANTS.wishlistPage,
      path: CONSTANTS.wishlistPage,
      pageBuilder: (context, state) =>
          NoTransitionPage<void>(
            key: state.pageKey, 
            child: WishlistPage(
              fromHome: state.extra == null, 
            ),
          ),
    ),
    GoRoute(
      name: CONSTANTS.searchResultsPage,
      path: CONSTANTS.searchResultsPage,
      pageBuilder: (context, state) =>
          NoTransitionPage<void>(
            key: state.pageKey, 
            child: SearchResultsPage(
              allItems: state.extra as List<Item>,
            ),
          ),
    ),
    GoRoute(
      path: CONSTANTS.profilePage,
      name: CONSTANTS.profilePage,
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const ProfilePage(),
      ),
    ),
  ],
);