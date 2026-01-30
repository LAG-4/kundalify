import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum LucideAsset { sparkles, star, arrowRight }

class LucideIcon extends StatelessWidget {
  const LucideIcon({
    super.key,
    required this.icon,
    required this.size,
    required this.color,
  });

  final LucideAsset icon;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _assetPath(icon),
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

String _assetPath(LucideAsset icon) {
  return switch (icon) {
    LucideAsset.sparkles => 'assets/icons/sparkles.svg',
    LucideAsset.star => 'assets/icons/star.svg',
    LucideAsset.arrowRight => 'assets/icons/arrow-right.svg',
  };
}
