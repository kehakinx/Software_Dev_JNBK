import 'package:flutter/material.dart';

class ResponsiveWrap extends StatefulWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;

  const ResponsiveWrap({
    super.key,
    required this.children,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
  });

  @override
  State<ResponsiveWrap> createState() => _ResponsiveWrapState();
}

class _ResponsiveWrapState extends State<ResponsiveWrap> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: widget.spacing,
          runSpacing: widget.runSpacing,
          runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          direction: Axis.horizontal,
          children: widget.children.map((child) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                // Handle tap if needed, or pass through
              },
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}