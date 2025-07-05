import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:closetinventory/models/item_dataobj.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClosetItemCard extends StatefulWidget {
  final Item closetItem;
  final double ratio;
  final bool shortSummary;

  const ClosetItemCard({
    super.key,
    required this.closetItem,
    this.ratio = 1.0,
    this.shortSummary = false,
  });

  @override
  State<ClosetItemCard> createState() => _ClosetItemCardState();
}

class _ClosetItemCardState extends State<ClosetItemCard> {
  
  
  @override
  Widget build(BuildContext context) {
    Color borderColor;
    if (widget.closetItem.wearCount == 0) {
      borderColor = Colors.red;
    } else if (widget.closetItem.isPlannedForDonation) {
      borderColor = Colors.orange;
    } else {
      borderColor = Colors.transparent;
    }
    return InkWell(
        onTap: () {
         context.pushNamed(CONSTANTS.viewItemPage, extra: widget.closetItem);
        },
        child: Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: 2),
      ),
      shadowColor: Colors.black45,
      child: SizedBox(
          height: 300 * widget.ratio,
          width: 180 * widget.ratio,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    color: Colors.grey[200],
                  ),
                  alignment: Alignment.center,
                  child: widget.closetItem.photoUrls!.isNotEmpty
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
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(12.0 * widget.ratio),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Text(
                        widget.closetItem.name,
                        style: TextStyle(
                        fontSize: 14 * widget.ratio,
                        fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!widget.shortSummary) ...[
                      SizedBox(height: 2 * widget.ratio),
                      Text(
                        widget.closetItem.summary,
                        style: TextStyle(fontSize: 10 * widget.ratio),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4 * widget.ratio),
                      Text(
                        'Worn: ${widget.closetItem.wearCount} times',
                        style: TextStyle(
                        fontSize: 10 * widget.ratio,
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