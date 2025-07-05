import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int number;
  final Color color;
  final String link;
  final String extra;
  final double height;
  final double width;
  final double ratio;
  final void Function(BuildContext context, String link)? onTap;

  const DashCard({
    super.key,
    required this.title,
    required this.icon,
    required this.number,
    required this.color,
    required this.link,
    this.extra = '',
    this.height = 135,
    this.width = 235,
    this.ratio = 1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(context, link);
        } else {
          context.pushNamed(link, extra: extra);
        }
      },
      child: Container(
        height: height * ratio,
        width: width * ratio,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.65), color.withOpacity(0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and number
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18 * ratio,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    number.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 28 * ratio,
                    ),
                  ),
                ],
              ),
            ),
            // Icon
            Icon(icon, size: 48 * ratio, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }
}
