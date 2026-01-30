import 'dart:ui';

import 'package:flutter/material.dart';

class GlassCircle extends StatelessWidget {
  const GlassCircle({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.blurSigma = 8,
    this.backgroundColor = const Color(0x0DFFFFFF),
    this.borderColor = const Color(0x1AFFFFFF),
    this.borderWidth = 1,
  });

  final Widget child;
  final EdgeInsets padding;
  final double blurSigma;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: child,
        ),
      ),
    );
  }
}
