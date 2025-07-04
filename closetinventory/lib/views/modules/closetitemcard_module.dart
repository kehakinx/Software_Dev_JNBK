import 'package:closetinventory/models/item_dataobj.dart';
import 'package:flutter/material.dart';

class ClosetItemCard extends StatelessWidget {
  final Item closetItem;
  final double ratio;

  const ClosetItemCard({
    super.key,
    required this.closetItem,
    this.ratio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    if (closetItem.wearCount == 0) {
      borderColor = Colors.red;
    } else if (closetItem.isPlannedForDonation) {
      borderColor = Colors.orange;
    } else {
      borderColor = Colors.transparent;
    }

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: 2),
      ),
      shadowColor: Colors.black45,
      child: SizedBox(
        height: 300 * ratio,
        width: 180 * ratio,
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
                  image: closetItem.photoUrls!.isNotEmpty  
                      ? DecorationImage(
                          image: NetworkImage(closetItem.photoUrls![0]),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: closetItem.photoUrls!.isEmpty
                    ? Text(
                        closetItem.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : null,
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      closetItem.summary,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Worn: ${closetItem.wearCount} times',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
