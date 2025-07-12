import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:closetinventory/models/outfit_dataobj.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OutfitCard extends StatefulWidget {
  final Outfit outfit;
  final double ratio;
  final bool shortSummary;
  final VoidCallback? outfitCallBack;
  final bool onTap;


  const OutfitCard({
    super.key,
    required this.outfit,
    this.ratio = 1.0,
    this.shortSummary = false,
    this.outfitCallBack,
    this.onTap = false,
  });

  @override
  State<OutfitCard> createState() => _OutfitCardState();
}

class _OutfitCardState extends State<OutfitCard> {

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
         if (widget.onTap) {
           // _performCallBack();
            
          }else{
            context.pushNamed(CONSTANTS.viewOutfitPage, extra: widget.outfit);
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
                          color: isSelected ? const Color.fromARGB(255, 147, 132, 232) : Colors.white,
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
                    color: const Color.fromARGB(255, 102, 122, 234),
                  ),
                  alignment: Alignment.center,
                  child: Center( child: Text(
                          widget.outfit.name,
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
                        widget.outfit.stylingNotes!,
                        style: TextStyle(fontSize: 8 * widget.ratio),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!widget.shortSummary) ...[
                      SizedBox(height: 4 * widget.ratio),
                      Text(
                        'Worn: ${widget.outfit.wearCount} times',
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
