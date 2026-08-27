import 'package:flutter/material.dart';
import 'breakpoints.dart';

class ContentWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const ContentWrapper({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final maxContentWidth = AppBreakpoints.maxContentWidth(width);
    final pagePadding = padding ?? EdgeInsets.symmetric(
      horizontal: AppBreakpoints.pagePadding(width),
      vertical: 12.0,
    );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: Padding(
          padding: pagePadding,
          child: child,
        ),
      ),
    );
  }
}
