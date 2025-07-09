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


  const ClosetItemCard({
    super.key,
    required this.closetItem,
    this.ratio = 1.0,
    this.shortSummary = false,
    this.closetItemCallBack,
    this.onTap = false,
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
  final Color closetItemBodySelected = Color(0xFFEBF4FF);


  Color closetItemDecoration = Colors.white;
  Color closetItemBorderColor = Colors.transparent;
  Color closetItemBody = Colors.white;
  bool isSelected = false;
  
  void _performCallBack(){
    if (widget.closetItemCallBack != null) {
      widget.closetItemCallBack!();
     // _selectCard();
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
        side: BorderSide(color: isSelected ? Colors.blue : Colors.transparent, width: 2),
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
                    color: const Color(0xFFEBF4FF),
                  ),
                  alignment: Alignment.center,
                  child: Center( child: widget.closetItem.photoUrls!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Image.network(
                            widget.closetItem.photoUrls!.first,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 48 * widget.ratio),
                          ),
                        )
                      : Text(
                          widget.closetItem.name,
                          style: TextStyle(
                            fontSize: 22 * widget.ratio,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                ),
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
}