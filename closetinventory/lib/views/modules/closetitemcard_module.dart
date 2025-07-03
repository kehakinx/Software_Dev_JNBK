import 'package:flutter/material.dart';

class ClosetItemCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final String summary;
  final int timesWorn;
  final bool isPlannedForDonation;

  const ClosetItemCard({
    super.key,
    required this.name,
    this.imageUrl,
    required this.summary,
    required this.timesWorn,
    this.isPlannedForDonation = false,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    if (timesWorn == 0) {
      borderColor = Colors.red;
    } else if (isPlannedForDonation) {
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
      child: Container(
        height: 300,
        width: 180,
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
                  image: imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: imageUrl == null
                    ? Text(
                        name,
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
                      summary,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Worn: $timesWorn times',
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
