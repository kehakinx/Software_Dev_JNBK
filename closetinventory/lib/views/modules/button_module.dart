import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomButtonModule extends StatelessWidget {
  final IconData? icon;
  final String title;
  final Color color;
  final String link;

  const CustomButtonModule({
    Key? key,
    this.icon,
    required this.title,
    required this.color,
    required this.link,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: icon != null
          ? Icon(icon, color: Colors.white)
          : const SizedBox.shrink(),
      label: Text(title, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {
        context.pushNamed(link);
      },
    );
  }
}
