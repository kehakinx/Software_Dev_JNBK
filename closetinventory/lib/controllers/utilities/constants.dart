import 'package:closetinventory/models/item_dataobj.dart';
import 'package:closetinventory/models/outfit_dataobj.dart';
import 'package:closetinventory/models/user_dataobj.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CONSTANTS {
  // COMMON APP VALUES
  static const String appName = 'Closet Inventory';
  static const String appVersion = '1.0.0';
  static const String appVersionCode = '';
  static const String appDescription =
      'Manage your wardrobe and outfits with ease.';
  static const String appLogo = 'assets/closetinventory.jpg';

  // COMMON APP ROUTES
  static const String splashPage = '/splash';
  static const String homePage = '/home';
  static const String loginPage = '/login';
  static const String registerPage = '/register';
  static const String onboardingPage = '/onboarding';

  static const String settingsPage = '/settings';

  static const String addItemPage = '/addItem';
  static const String addOutfitPage = '/addOutfit';
  static const String addLocationPage = '/addLocation';
  static const String addWishListPage = '/addWishList';
  static const String addWearLogPage = '/addWearLog';

  static const String viewItemPage = '/viewItem';
  static const String viewallItemsPage = '/viewallItems';
  static const String viewOutfitPage = '/viewOutfit';
  static const String viewLocationPage = '/viewLocation';
  static const String viewWishListPage = '/viewWishList';
  static const String viewAnalysisPage = '/viewAnalysis';
  static const String viewWearLogPage = '/viewWearLog';
  static const String viewDeclutterPage = '/viewDeclutter';

  // COMMON APP COLLECTIONS
  static const String usersCollection = 'users';
  static const String itemsCollection = 'items';
  static const String outfitsCollection = 'outfits';
  static const String locationsCollection = 'locations';
  static const String wishListsCollection = 'wishlists';
  static const String wearLogsCollection = 'wearlogs';
  static const String declutterCollection = 'declutter';
  static const String eventLogsCollection = 'eventlogs';

  // COMMON USER ERROR MESSAGES
  // ENGLISH
  static const String networkErrorEn = 'Network error. Please try again later.';
  static const String serverErrorEn = 'Server error. Please try again later.';
  static const String unknownErrorEn =
      'An unknown error occurred. Please try again.';
  static const String itemNotFoundErrorEn = 'Item not found.';
  static const String invalidInputErrorEn =
      'Invalid input. Please check your data.';
  static const String itemAlreadyExistsErrorEn = 'Item already exists.';
  static const String itemNoRecordsErrorEn =
      'No items found.';
  // SPANISH
  static const String networkErrorEs =
      'Error de red. Por favor, inténtelo de nuevo más tarde.';
  static const String serverErrorEs =
      'Error del servidor. Por favor, inténtelo de nuevo más tarde.';
  static const String unknownErrorEs =
      'Ocurrió un error desconocido. Por favor, inténtelo de nuevo.';
  static const String itemNotFoundErrorEs = 'Artículo no encontrado.';
  static const String invalidInputErrorEs =
      'Entrada inválida. Por favor, revise sus datos.';
  static const String itemAlreadyExistsErrorEs = 'El artículo ya existe.';
  static const String itemNoRecordsErrorEs =
      'No se encontraron artículos.';

  // COMMON APP STRINGS
  // ENGLISH
  static const String welcomeTextEn = 'Welcome to Closet Inventory';
  static const String loginTextEn = 'Login';
  static const String registerTextEn = 'Register';
  static const String logoutTextEn = 'Logout';
  static const String settingsTextEn = 'Settings';
  static const String addItemTextEn = 'Add Item';
  static const String addOutfitTextEn = 'Add Outfit';
  static const String addLocationTextEn = 'Add Location';
  static const String addWishListTextEn = 'Add Wish List';
  static const String addWearLogTextEn = 'Add Wear Log';
  static const String viewItemTextEn = 'View Item';
  static const String viewOutfitTextEn = 'View Outfit';
  static const String viewLocationTextEn = 'View Location';
  static const String viewWishListTextEn = 'View Wish List';
  static const String viewAnalysisTextEn = 'View Analysis';
  static const String viewWearLogTextEn = 'View Wear Log';
  static const String viewDeclutterTextEn = 'View Declutter';
  static const String dashboardClosetTextEn = 'My Closet Dashboard';
  static const String dashboardDigitalClosetTextEn = 'My Digital Closet';
  // SPANISH
  static const String welcomeTextEs = 'Bienvenido a Closet Inventory';
  static const String loginTextEs = 'Iniciar sesión';
  static const String registerTextEs = 'Registrarse';
  static const String logoutTextEs = 'Cerrar sesión';
  static const String settingsTextEs = 'Configuración';
  static const String addItemTextEs = 'Agregar artículo';
  static const String addOutfitTextEs = 'Agregar atuendo';
  static const String addLocationTextEs = 'Agregar ubicación';
  static const String addWishListTextEs = 'Agregar lista de deseos';
  static const String addWearLogTextEs = 'Agregar registro de uso';
  static const String viewItemTextEs = 'Ver artículo';
  static const String viewOutfitTextEs = 'Ver atuendo';
  static const String viewLocationTextEs = 'Ver ubicación';
  static const String viewWishListTextEs = 'Ver lista de deseos';
  static const String viewAnalysisTextEs = 'Ver análisis';
  static const String viewWearLogTextEs = 'Ver registro de uso';
  static const String viewDeclutterTextEs = 'Ver decluttering';
  static const String dashboardClosetTextEs = 'Mi panel de control del armario';
  static const String dashboardDigitalClosetTextEs = 'Mi armario digital';

  // COMMON APP LANGUAGE CODES
  static const String enLanguageCode = 'En';
  static const String esLanguageCode = 'Es';

  // COMMON APP THEMES
  static const String lightTheme = 'light';
  static const String darkTheme = 'dark';
  static const String systemTheme = 'system';

  // COMMON APP COLORS
  static const Color primaryColor = Color(0xFF6200EE); // Purple
  static const Color secondaryColor = Color(0xFF03DAC6); // Teal
  static const Color primaryLightColor = Color(0xFFBB86FC); // Light Purple
  static const Color secondaryLightColor = Color(0xFF03DAC5); // Light Teal
  static const Color primaryDarkColor = Color(0xFF3700B3); // Dark Purple
  static const Color secondaryDarkColor = Color(0xFF018786); // Dark Teal
  static const Color primaryAccentColor = Color(0xFF03DAC5); // Teal
  static const Color secondaryAccentColor = Color(0xFF03DAC6); // Light Teal
  static const Color primaryBackgroundColor = Color(0xFFFFFFFF); // White
  static const Color secondaryBackgroundColor = Color(0xFFF5F5F5); // Light Grey
  static const Color primaryCardColor = Color(0xFFFFFFFF); // White
  static const Color secondaryCardColor = Color(0xFFF5F5F5); // Light Grey
  static const Color primaryButtonColor = Color(0xFF6200EE); // Purple
  static const Color secondaryButtonColor = Color(0xFF03DAC6); // Teal
  static const Color disabledButtonColor = Color(0xFFBDBDBD);
  static const Color errorColor = Color(0xFFB00020); // Red
  static const Color successColor = Color(0xFF4CAF50); // Green
  static const Color warningColor = Color.fromRGBO(233, 139, 8, 0.79); // Amber
  static const Color infoColor = Color(0xFF2196F3); // Blue
  static const Color primaryTextColor = Color(0xFF000000); // Black
  static const Color secondaryTextColor = Color(0xFF757575); // Grey
  static const Color dividerColor = Color(0xFFBDBDBD); // Light Grey

  // SHARED PREFERENCES KEYS
  static const String themePreferenceKey = 'theme_preference';
  static const String languagePreferenceKey = 'language_preference';
  static const String isOnboarded = 'is_onboarded';

  // MOCK DATA
  static const List<String> categories = [
    'Tops',
    'Bottoms',
    'Dresses',
    'Outerwear',
    'Shoes',
    'Accessories',
    'Other',
  ];

  static List<USER> mockUsers = [
    USER.fromJson({
      'userId': 'user123',
      'email': 'john.doe@example.com',
      'displayName': 'John Doe',
      'profilePic': '',
      }),
        USER.fromJson({
      'userId': 'user456',
      'email': 'jane.doe@example.com',
      'displayName': 'Jane Doe',
      'profilePic': '',
        }),
        USER.fromJson({
      'userId': 'user789',
      'email': 'alex.smith@example.com',
      'displayName': 'Alex Smith',
      'profilePic': '',
        }),
        USER.fromJson({
      'userId': 'user321',
      'email': 'maria.garcia@example.com',
      'displayName': 'Maria Garcia',
      'profilePic': '',
        }),
  ];
    
  static List<Item> mockClosetItems = [
    Item.fromJson({
      'itemId': '1',
      'userId': 'user123',
      'name': 'Blue Jeans',
      'type': 'Bottoms',
      'wearCount': 10,
    }),
    Item.fromJson({
      'itemId': '2',
      'userId': 'user123',
      'name': 'White T-Shirt',
      'type': 'Tops',
      'wearCount': 0,
    }),
    Item.fromJson({
      'itemId': '3',
      'userId': 'user123',
      'name': 'Black Sneakers',
      'type': 'Shoes',
      'wearCount': 8,
    }),
    Item.fromJson({
      'itemId': '4',
      'userId': 'user123',
      'name': 'Red Dress',
      'type': 'Dresses',
      'wearCount': 5,
    }),
    Item.fromJson({
      'itemId': '5',
      'userId': 'user123',
      'name': 'Grey Hoodie',
      'type': 'Outerwear',
      'wearCount': 12,
    }),
    Item.fromJson({
      'itemId': '6',
      'userId': 'user123',
      'name': 'Green Scarf',
      'type': 'Accessories',
      'wearCount': 3,
    }),
    Item.fromJson({
      'itemId': '7',
      'userId': 'user123',
      'name': 'Brown Belt',
      'type': 'Accessories',
      'wearCount': 7,
    }),
    Item.fromJson({
      'itemId': '8',
      'userId': 'user123',
      'name': 'Yellow Raincoat',
      'type': 'Outerwear',
      'wearCount': 2,
    }),
    Item.fromJson({
      'itemId': '9',
      'userId': 'user123',
      'name': 'Blue Cap',
      'type': 'Accessories',
      'wearCount': 4,
    }),
    Item.fromJson({
      'itemId': '10',
      'userId': 'user123',
      'name': 'White Socks',
      'type': 'Shoes',
      'wearCount': 15,
    }),
    // Items for user456 (Jane Doe)
    Item.fromJson({
      'itemId': '11',
      'userId': 'user456',
      'name': 'Pink Blouse',
      'type': 'Tops',
      'wearCount': 6,
    }),
    Item.fromJson({
      'itemId': '12',
      'userId': 'user456',
      'name': 'Black Skirt',
      'type': 'Bottoms',
      'wearCount': 4,
    }),
    Item.fromJson({
      'itemId': '13',
      'userId': 'user456',
      'name': 'White Heels',
      'type': 'Shoes',
      'wearCount': 2,
    }),
    Item.fromJson({
      'itemId': '14',
      'userId': 'user456',
      'name': 'Beige Trench Coat',
      'type': 'Outerwear',
      'wearCount': 3,
    }),
    Item.fromJson({
      'itemId': '15',
      'userId': 'user456',
      'name': 'Gold Necklace',
      'type': 'Accessories',
      'wearCount': 7,
    }),
    // Items for user789 (Alex Smith)
    Item.fromJson({
      'itemId': '16',
      'userId': 'user789',
      'name': 'Grey Suit Jacket',
      'type': 'Outerwear',
      'wearCount': 5,
      'photoUrls': ['https://image.hm.com/assets/hm/23/74/23744d23f93f8522bacd4e6764ff164c14b71cfd.jpg?imwidth=820'],
    }),
    Item.fromJson({
      'itemId': '26',
      'userId': 'user789',
      'name': 'White Pocket Square',
      'type': 'Accessories',
      'wearCount': 3,
      'photoUrls': ['https://image.menswearhouse.com/is/image/TMW/TMW_88MM_19_JOSEPH_FEISS_GOLD_POCKET_SQUARES_WHITE_MAIN?imPolicy=pdp-zoom'],
    }),
    Item.fromJson({
      'itemId': '27',
      'userId': 'user789',
      'name': 'Navy Blue Tie',
      'type': 'Accessories',
      'wearCount': 6,
      'isPlannedForDonation': true,
      'photoUrls': ['https://m.media-amazon.com/images/I/71LMLfed-YL._AC_SX569_.jpg'],
    }),
    Item.fromJson({
      'itemId': '28',
      'userId': 'user789',
      'name': 'Black Leather Belt',
      'type': 'Accessories',
      'wearCount': 7,
    }),
    Item.fromJson({
      'itemId': '17',
      'userId': 'user789',
      'name': 'Blue Dress Shirt',
      'type': 'Tops',
      'wearCount': 8,
    }),
    Item.fromJson({
      'itemId': '18',
      'userId': 'user789',
      'name': 'Black Dress Pants',
      'type': 'Bottoms',
      'wearCount': 6,
      'photoUrls': ['https://cdn.shopify.com/s/files/1/0293/9277/files/01-16-25_S2_15_GW24K1947A_Black_P_CXB_AA_15-25-43_30692_PXF.jpg?v=1737156594&width=600&height=900&crop=center'],
    }),
    Item.fromJson({
      'itemId': '19',
      'userId': 'user789',
      'name': 'Brown Loafers',
      'type': 'Shoes',
      'wearCount': 4,
    }),
    Item.fromJson({
      'itemId': '20',
      'userId': 'user789',
      'name': 'Silver Watch',
      'type': 'Accessories',
      'wearCount': 9,
    }),
    // Items for user321 (Maria Garcia)
    Item.fromJson({
      'itemId': '21',
      'userId': 'user321',
      'name': 'Red Cardigan',
      'type': 'Outerwear',
      'wearCount': 7,
    }),
    Item.fromJson({
      'itemId': '22',
      'userId': 'user321',
      'name': 'Floral Dress',
      'type': 'Dresses',
      'wearCount': 5,
    }),
    Item.fromJson({
      'itemId': '23',
      'userId': 'user321',
      'name': 'White Sandals',
      'type': 'Shoes',
      'wearCount': 3,
    }),
    Item.fromJson({
      'itemId': '24',
      'userId': 'user321',
      'name': 'Blue Denim Jacket',
      'type': 'Outerwear',
      'wearCount': 6,
    }),
    Item.fromJson({
      'itemId': '25',
      'userId': 'user321',
      'name': 'Pearl Earrings',
      'type': 'Accessories',
      'wearCount': 8,
    }),
  ];

  static List<Outfit> mockOutfits = [
    Outfit.fromJson({
      'outfitId': '1',
      'userId': 'user123',
      'name': 'Casual Look',
      'itemIds': ['1', '2', '3'],
      'stylingNotes': 'Perfect for a casual day out.',
      'wareCount': 5,
    }),
    Outfit.fromJson({
      'outfitId': '2',
      'userId': 'user123',
      'name': 'Office Attire',
      'itemIds': ['4', '5', '6'],
      'stylingNotes': 'Professional and stylish.',
      'wareCount': 3,
    }),
    Outfit.fromJson({
      'outfitId': '3',
      'userId': 'user123',
      'name': 'Rainy Day',
      'itemIds': ['8', '9', '10'],
      'stylingNotes': 'Stay dry and comfortable.',
      'wareCount': 2,
    }),
    Outfit.fromJson({
      'outfitId': '4',
      'userId': 'user123',
      'name': 'Weekend Vibes',
      'itemIds': ['2', '7', '3'],
      'stylingNotes': 'Relaxed and easy-going.',
      'wareCount': 4,
    }),
    // Outfits for user456 (Jane Doe)
    Outfit.fromJson({
      'outfitId': '5',
      'userId': 'user456',
      'name': 'Elegant Evening',
      'itemIds': ['11', '12', '13'],
      'stylingNotes': 'Perfect for a night out.',
      'wareCount': 2,
    }),
    Outfit.fromJson({
      'outfitId': '6',
      'userId': 'user456',
      'name': 'Chic Workday',
      'itemIds': ['11', '14', '15'],
      'stylingNotes': 'Stylish and professional.',
      'wareCount': 3,
    }),
    // Outfits for user789 (Alex Smith)
    Outfit.fromJson({
      'outfitId': '7',
      'userId': 'user789',
      'name': 'Business Formal',
      'itemIds': ['16', '17', '18', '20'],
      'stylingNotes': 'For important meetings.',
      'wareCount': 4,
    }),
    Outfit.fromJson({
      'outfitId': '8',
      'userId': 'user789',
      'name': 'Smart Casual',
      'itemIds': ['17', '18', '19'],
      'stylingNotes': 'Comfortable yet sharp.',
      'wareCount': 2,
    }),
    // Outfits for user321 (Maria Garcia)
    Outfit.fromJson({
      'outfitId': '9',
      'userId': 'user321',
      'name': 'Spring Day',
      'itemIds': ['21', '22', '23'],
      'stylingNotes': 'Light and colorful.',
      'wareCount': 3,
    }),
    Outfit.fromJson({
      'outfitId': '10',
      'userId': 'user321',
      'name': 'Denim Style',
      'itemIds': ['24', '25', '23'],
      'stylingNotes': 'Trendy and casual.',
      'wareCount': 1,
    }),
  ];
}
