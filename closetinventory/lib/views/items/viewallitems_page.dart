import 'package:closetinventory/controllers/utilities/shared_preferences.dart';
import 'package:closetinventory/models/item_dataobj.dart';
import 'package:closetinventory/models/user_dataobj.dart';
import 'package:closetinventory/views/modules/closetitemcard_module.dart';
import 'package:closetinventory/views/modules/responsivewrap_module.dart';
import 'package:flutter/material.dart';
import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:closetinventory/controllers/utilities/platform_service.dart';

class ViewallitemsPage extends StatefulWidget {
  final bool unworn;
  final bool declutter;

  const ViewallitemsPage({
    super.key,
    this.unworn = false,
    this.declutter = false,
    });

  @override
  State<ViewallitemsPage> createState() => _ViewallitemsPageState();
}

class _ViewallitemsPageState extends State<ViewallitemsPage> {
  final PlatformService _platformService = PlatformService.instance;
  MyPreferences _myPreferences = MyPreferences();
  late List<Item> _closetItems;
  late USER _user;

  @override
  void initState() {
    super.initState();

    // Always create a new instance (copy) of the mockClosetItems list
    _user = CONSTANTS.mockUsers.firstWhere((user) => user.userId == MyPreferences.getString('prefUserKey'));
    _closetItems = List<Item>.from(CONSTANTS.mockClosetItems.where((item) => item.userId == _user.userId));
    
    if (widget.unworn) {
      _closetItems.retainWhere((item) => item.wearCount == 0);
    } else if (widget.declutter) {
      _closetItems.retainWhere((item) => item.isPlannedForDonation == true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View All Clothing Items'),
      ),
      body: 
      SafeArea(
        child: _closetItems.isEmpty
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
            _closetItems.length,
            (index) => ClosetItemCard(
              closetItem: _closetItems.elementAt(index),
              ratio: _platformService.isWeb ? 1 : .85,
            ),
          ),
            ),
          ),
      ),
    );
  }
}