import 'dart:async';

import 'package:closetinventory/controllers/firebase/authentication_service.dart';
import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:closetinventory/controllers/utilities/platform_service.dart';
import 'package:closetinventory/controllers/utilities/shared_preferences.dart';
import 'package:closetinventory/models/outfit_dataobj.dart';
import 'package:closetinventory/views/modules/outfitcard_module.dart';
import 'package:closetinventory/views/modules/responsivewrap_module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewalloutfitsPage extends StatefulWidget {
  

  const ViewalloutfitsPage({
    super.key,
    });

  @override
  State<ViewalloutfitsPage> createState() => _ViewalloutfitsPageState();
}

class _ViewalloutfitsPageState extends State<ViewalloutfitsPage> {
  final PlatformService _platformService = PlatformService.instance;
  final FirebaseAuthServices _authServices = FirebaseAuthServices();
  late String _userId;
  late List<Outfit> _outiftItems = [];
  StreamSubscription? _outfitSubscription;
  //ClosetFilter? closetFilter ;

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
    _outfitSubscription?.cancel();
   
    _outfitSubscription = _authServices.getDataServices().getFirestore().collection(CONSTANTS.outfitsCollection).where('userId', isEqualTo: _userId).snapshots().listen((snapshot){
      if(!mounted) return;

      setState(() {
        _outiftItems = snapshot.docs.map((doc) => Outfit.fromDocument(doc)).toList();

        List<Outfit> tempFilteredItems = List<Outfit>.from(_outiftItems); // Create a temporary list for filtering

        _outiftItems = tempFilteredItems; // Update _filteredItems with initial filtered list

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
    _outfitSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: const Text('View All Outfits'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /*Padding(
              padding: const EdgeInsets.all(12.0),
              child: closetFilter
            ),*/
            Expanded(
              child: _outiftItems.isEmpty
                  ? Center(
                      child: Text(
                        CONSTANTS.itemNoRecordsErrorEn,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: ResponsiveWrap(
                        children: List.generate(
                          _outiftItems.length,
                          (index) => OutfitCard(
                            outfit: _outiftItems.elementAt(index),
                            ratio: _platformService.isWeb ? 1 : .85,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

}