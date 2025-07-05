import 'package:closetinventory/views/modules/closetitemcard_module.dart';
import 'package:closetinventory/views/modules/responsivewrap_module.dart';
import 'package:flutter/material.dart';
import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:closetinventory/controllers/utilities/platform_service.dart';

class ViewallitemsPage extends StatefulWidget {
  const ViewallitemsPage({super.key});

  @override
  State<ViewallitemsPage> createState() => _ViewallitemsPageState();
}

class _ViewallitemsPageState extends State<ViewallitemsPage> {
  final PlatformService _platformService = PlatformService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View All Clothing Items'),
      ),
      body: 
      SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ResponsiveWrap(
            children:  List.generate(
              CONSTANTS.mockClosetItems.length,
              (index) => ClosetItemCard( 
                closetItem: CONSTANTS.mockClosetItems.elementAt(index),
                ratio: _platformService.isWeb ? 1 : .85,
              ),
            ),
          ),
        ),
      ),
    );
  }
}