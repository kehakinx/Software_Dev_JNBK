import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomButtonModule extends StatelessWidget {
  final IconData? icon;
  final String title;
  final Color color;
  final String? link;
  final double height;
  final double width;
  final double ratio;
  final VoidCallback? onTap;

  const CustomButtonModule({
    super.key,
    this.icon,
    required this.title,
    required this.color,
    this.link,
    this.height = 50,
    this.width = 200,
    this.ratio = 1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: height * ratio,
      width: width * ratio,
      child: ElevatedButton.icon(
        icon: icon != null
            ? Icon(icon, color: Colors.white)
            : const SizedBox.shrink(),
        label: Text(title, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: Size(width * ratio, height * ratio),
        ),
        onPressed:
            onTap ??
            () {
              if (link != null) {
                context.pushNamed(link!);
              }
            },
      ),
    );
  }
}
