import 'package:closetinventory/controllers/firebase/authentication_service.dart';
import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:closetinventory/controllers/utilities/platform_service.dart';
import 'package:closetinventory/views/modules/button_module.dart';
import 'package:closetinventory/views/modules/dashcard_module.dart';
import 'package:closetinventory/views/modules/closetitemcard_module.dart';
import 'package:flutter/material.dart';

// Dummy DashCardModule widget for demonstration
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuthServices _firebaseAuth = FirebaseAuthServices();
  final PlatformService _platformService = PlatformService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _platformService.isWeb
                ? Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          CONSTANTS.dashboardClosetTextEn,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      CustomButtonModule(
                        icon: Icons.add,
                        title: 'Add New Item',
                        color: CONSTANTS.infoColor,
                        link: CONSTANTS.addItemPage,
                      ),
                      const SizedBox(width: 8),
                      CustomButtonModule(
                        title: 'Plan Outfits',
                        color: CONSTANTS.primaryButtonColor,
                        link: CONSTANTS.addOutfitPage,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          CONSTANTS.dashboardClosetTextEn,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomButtonModule(
                            icon: Icons.add,
                            title: 'Add New Item',
                            color: CONSTANTS.infoColor,
                            link: CONSTANTS.addItemPage,
                            ratio: .8,
                          ),
                          const SizedBox(width: 8),
                          CustomButtonModule(
                            title: 'Plan Outfits',
                            color: CONSTANTS.primaryButtonColor,
                            link: CONSTANTS.addOutfitPage,
                            ratio: .8,
                          ),
                        ],
                      ),
                    ],
                  ),
            _platformService.isWeb
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DashCard(
                            title: "Total Items",
                            icon: Icons.checkroom,
                            number: 215,
                            color: CONSTANTS.primaryButtonColor,
                            link: CONSTANTS.splashPage,
                          ),
                          DashCard(
                            title: "Saved Outfits",
                            icon: Icons.assignment_outlined,
                            number: 38,
                            color: CONSTANTS.successColor,
                            link: CONSTANTS.homePage,
                          ),
                          DashCard(
                            title: "Unworn Items",
                            icon: Icons.warning_amber,
                            number: 15,
                            color: CONSTANTS.warningColor,
                            link: CONSTANTS.homePage,
                          ),
                          DashCard(
                            title: "To Declutter",
                            icon: Icons.delete_outline,
                            number: 7,
                            color: CONSTANTS.errorColor,
                            link: CONSTANTS.homePage,
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DashCard(
                            title: "Total Items",
                            icon: Icons.checkroom, // Plus icon
                            number: 215,
                            color: CONSTANTS.primaryButtonColor,
                            link: CONSTANTS.splashPage,
                            ratio: .70,
                          ),
                          DashCard(
                            title: "Saved Outfits",
                            icon: Icons.assignment_outlined, // Plus icon
                            number: 38,
                            color: CONSTANTS.successColor,
                            link: CONSTANTS.homePage,
                            ratio: 0.70,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DashCard(
                            title: "Unworn Items",
                            icon: Icons.warning_amber, // Plus icon
                            number: 15,
                            color: CONSTANTS.warningColor,
                            link: CONSTANTS.homePage,
                            ratio: 0.70,
                          ),
                          DashCard(
                            title: "To Declutter",
                            icon: Icons.delete_outline, // Plus icon
                            number: 7,
                            color: CONSTANTS.errorColor,
                            link: CONSTANTS.homePage,
                            ratio: 0.70,
                          ),
                        ],
                      ),
                    ],
                  ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                CONSTANTS.dashboardDigitalClosetTextEn,
                style: TextStyle(
                  fontSize: _platformService.isWeb ? 36 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 300,
              child: PageView.builder(
                padEnds: false,
                controller: PageController(viewportFraction: .33),
                itemCount: CONSTANTS
                    .mockClosetItems
                    .length, // Replace with your item count
                itemBuilder: (context, index) {
                  final item = CONSTANTS.mockClosetItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClosetItemCard(
                      name: item.entries.elementAt(1).value,
                      summary: item.entries.elementAt(2).value,
                      timesWorn: item.entries.elementAt(3).value,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
