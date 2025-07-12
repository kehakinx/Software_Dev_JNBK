import 'package:flutter/material.dart';
import 'package:closetinventory/models/item_dataobj.dart';

// This is a mock/fake version of EditItemPage for UI testing without Firebase.
class EditItemPageTrial extends StatefulWidget {
  final Item closetItem;
  const EditItemPageTrial({Key? key, required this.closetItem}) : super(key: key);

  @override
  State<EditItemPageTrial> createState() => _EditItemPageTrialState();
}

class _EditItemPageTrialState extends State<EditItemPageTrial> {
  late bool _isPlannedForDonation;

  @override
  void initState() {
    super.initState();
    _isPlannedForDonation = widget.closetItem.isPlannedForDonation;
  }

  void _markAsDonated() {
    setState(() {
      _isPlannedForDonation = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item marked for donation!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Clothing Item')),
      body: Center(
        child: ElevatedButton(
          onPressed: _isPlannedForDonation ? null : _markAsDonated,
          child: Text(_isPlannedForDonation ? 'Donated' : 'Mark as Donate'),
        ),
      ),
    );
  }
}