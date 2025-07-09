import 'dart:async';

import 'package:closetinventory/controllers/firebase/authentication_service.dart';
import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:closetinventory/controllers/utilities/platform_service.dart';
import 'package:closetinventory/controllers/utilities/shared_preferences.dart';
import 'package:closetinventory/models/item_dataobj.dart';
import 'package:closetinventory/models/outfit_dataobj.dart';
import 'package:closetinventory/views/modules/button_module.dart';
import 'package:closetinventory/views/modules/dashcard_module.dart';
import 'package:closetinventory/views/modules/closetitemcard_module.dart';
import 'package:closetinventory/views/modules/responsivewrap_module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {

  const HomePage({
    super.key,
    });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PlatformService _platformService = PlatformService.instance;
  final FirebaseAuthServices _authServices = FirebaseAuthServices();
  late String _userId;
  late List<Item> _closetItems = [];
  late List<Outfit> _outfits = [];
  StreamSubscription? _itemSubscription;
  StreamSubscription? _outfitSubscription;

  @override
  void initState() {
    super.initState();
      _initializeFirebaseAndAuth();
  }

  Future<void> _initializeFirebaseAndAuth() async{
    _authServices.getAuth().authStateChanges().listen((User? user){
      if(user != null){
        setState(() {
          _userId = MyPreferences.getString('prefUserKey');
        });
        _loadCloset();
      }else{
        mounted ? context.go(CONSTANTS.loginPage) : null;
      }
    });
  }

  Future<void> _loadCloset() async {
    _itemSubscription?.cancel();
   
    _itemSubscription = _authServices.getDataServices().getFirestore().collection(CONSTANTS.itemsCollection).where('userId', isEqualTo: _userId).snapshots().listen((snapshot){
      if(!mounted) return;

      setState(() {
        _closetItems = snapshot.docs.map((doc) => Item.fromDocument(doc)).toList();
      });
    },
    onError: (error){
      if(!mounted) return;
      setState(() {
        
      });
    });

    _outfitSubscription?.cancel();

    _outfitSubscription = _authServices.getDataServices().getFirestore().collection(CONSTANTS.outfitsCollection).where('userId', isEqualTo: _userId).snapshots().listen((snapshot){
      if(!mounted) return;

      setState(() {
        _outfits = snapshot.docs.map((doc) => Outfit.fromDocument(doc)).toList();
      });
    },
    onError: (error){
      if(!mounted) return;
      setState(() {
        
      });
    });
  }

   @override
   void dispose(){
    _itemSubscription?.cancel();
    _outfitSubscription?.cancel();

    super.dispose();
   }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ResponsiveWrap(
                children: [ 
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: 
                      Text(
                        CONSTANTS.dashboardClosetTextEn,
                        style: TextStyle(
                            fontSize: _platformService.isWeb ? 48 : 30,
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
                        ratio: _platformService.isWeb ? 1 : .8
                      ),
                  const SizedBox(width: 8),
                  CustomButtonModule(
                        title: 'Plan Outfits',
                        color: CONSTANTS.primaryButtonColor,
                        link: CONSTANTS.addOutfitPage,
                        ratio: _platformService.isWeb ? 1 : .8
                      ),
                ],
              ),
               ResponsiveWrap(
                children: [ 
                  DashCard(
                    title: "Total Items",
                    icon: Icons.checkroom,
                    number: _closetItems.length,
                    color: CONSTANTS.primaryButtonColor,
                    link: CONSTANTS.viewallItemsPage,
                    ratio: _platformService.isWeb ? 1 : .7,
                  ),
                  DashCard(
                    title: "Saved Outfits",
                    icon: Icons.assignment_outlined,
                    number: _outfits.length,
                    color: CONSTANTS.successColor,
                    link: CONSTANTS.homePage,
                    ratio: _platformService.isWeb ? 1 : .7,
                  ),
                  DashCard(
                    title: "Unworn Items",
                    icon: Icons.warning_amber,
                    number: _closetItems.where((context) => context.wearCount == 0).length,
                    color: CONSTANTS.warningColor,
                    link: CONSTANTS.viewallItemsPage,
                    extra: "unWorn",
                    ratio: _platformService.isWeb ? 1 : .7,
                  ),
                  DashCard(
                    title: "To Declutter",
                    icon: Icons.delete_outline,
                    number: _closetItems.where((context) => context.isPlannedForDonation == true).length,
                    color: CONSTANTS.errorColor,
                    link: CONSTANTS.viewallItemsPage,
                    extra: "declutter",
                    ratio: _platformService.isWeb ? 1 : .7,
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
              ResponsiveWrap(
                children: [ 
                  SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _closetItems.length,
                      itemBuilder: (context, index) {
                        final item = _closetItems[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ClosetItemCard(
                            closetItem: item,
                            ratio: _platformService.isWeb ? 1 : .85,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomButtonModule(
                title: 'View All Items',
                color: CONSTANTS.disabledButtonColor,
                link: CONSTANTS.viewallItemsPage,
              ),
            ],
          )
        ),
      ),
    );
  }
}