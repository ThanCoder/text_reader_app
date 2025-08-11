import 'package:flutter/material.dart';

class ScrollableColumn extends StatelessWidget {
  List<Widget> children;
  EdgeInsetsGeometry padding;
  MainAxisAlignment mainAxisAlignment;
  MainAxisSize mainAxisSize;
  CrossAxisAlignment crossAxisAlignment;
  TextDirection? textDirection;
  VerticalDirection verticalDirection;
  TextBaseline? textBaseline;
  double spacing;
  ScrollableColumn({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(8.0),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.spacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
        spacing: spacing,
        children: children,
      ),
    ));
  }
}
