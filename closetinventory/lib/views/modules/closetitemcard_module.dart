import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:closetinventory/models/item_dataobj.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClosetItemCard extends StatefulWidget {
  final Item closetItem;
  final double ratio;
  final bool shortSummary;
  final VoidCallback? closetItemCallBack;
  final bool onTap;
  final bool isSelected;

  const ClosetItemCard({
    super.key,
    required this.closetItem,
    this.ratio = 1.0,
    this.shortSummary = false,
    this.closetItemCallBack,
    this.onTap = false,
    this.isSelected = false,
  });

  @override
  State<ClosetItemCard> createState() => _ClosetItemCardState();
}

class _ClosetItemCardState extends State<ClosetItemCard> {
  final Color closetItem = Colors.transparent;
  final Color closetItemSelectedDecoration = Colors.blue;
  final Color closetItemUnSelectedDecoration = Colors.white;
  final Color closetItemUnworn = Colors.red;
  final Color closetItemDeclutter = Colors.orange;
  final Color closetItemBodySelected = const Color(0xFFEBF4FF);

  Color closetItemDecoration = Colors.white;
  Color closetItemBorderColor = Colors.transparent;
  Color closetItemBody = Colors.white;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  void _performCallBack(){
    if (widget.closetItemCallBack != null) {
      widget.closetItemCallBack!();
     
     if(isSelected) {
       closetItemDecoration = closetItemSelectedDecoration;
       closetItemBorderColor = closetItemSelectedDecoration;
       closetItemBody = closetItemBodySelected;
       isSelected = false;
     }else{
      closetItemDecoration = closetItemUnSelectedDecoration;
      closetItemBorderColor = closetItem;
      closetItemBody = closetItemUnSelectedDecoration;
      isSelected = true;
     }
    }
  }

  bool _hasPhoto() {
    return widget.closetItem.photoUrls != null && 
           widget.closetItem.photoUrls!.isNotEmpty &&
           widget.closetItem.photoUrls!.first.isNotEmpty &&
           widget.closetItem.photoUrls!.first.startsWith('https://firebasestorage.googleapis.com');
  }
   
  @override
  Widget build(BuildContext context) {
    
    if (widget.closetItem.wearCount == 0) {
      closetItemBorderColor = closetItemUnworn;
    } else if (widget.closetItem.isPlannedForDonation) {
      closetItemBorderColor = closetItemDeclutter;
    } else {
      closetItemBorderColor = closetItem;
    }
    return InkWell(
        onTap: () {
         if (widget.onTap) {
            _performCallBack();
            
          }else{
            context.pushNamed(CONSTANTS.viewItemPage, extra: widget.closetItem);
          }
        },
        child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isSelected ? Colors.blue : closetItemBorderColor, width: 2),
      ),
      shadowColor: Colors.black45,
      child: Container(
          height: 250 * widget.ratio,
          width: 180 * widget.ratio,
          decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFEBF4FF) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    color: Colors.grey[100],
                  ),
                  child: _hasPhoto() ? _buildPhotoWidget() : _buildNoPhotoWidget(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(8 * widget.ratio),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Text(
                        widget.closetItem.name,
                        style: TextStyle(
                        fontSize: 10 * widget.ratio,
                        fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2 * widget.ratio),
                      Text(
                        widget.closetItem.summary,
                        style: TextStyle(fontSize: 8 * widget.ratio),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!widget.shortSummary) ...[
                      SizedBox(height: 4 * widget.ratio),
                      Text(
                        'Worn: ${widget.closetItem.wearCount} times',
                        style: TextStyle(
                        fontSize: 8 * widget.ratio,
                        fontWeight: FontWeight.w500,
                        ),
                      ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoWidget() {
    final imageUrl = widget.closetItem.photoUrls!.first;
    
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(12),
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.green[50],
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 32 * widget.ratio,
                  color: Colors.green,
                ),
                SizedBox(height: 4 * widget.ratio),
                Text(
                  'Photo Uploaded',
                  style: TextStyle(
                    fontSize: 10 * widget.ratio,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoPhotoWidget() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checkroom,
            size: 40 * widget.ratio,
            color: Colors.grey[400],
          ),
          SizedBox(height: 8 * widget.ratio),
          Text(
            widget.closetItem.name,
            style: TextStyle(
              fontSize: 12 * widget.ratio,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}