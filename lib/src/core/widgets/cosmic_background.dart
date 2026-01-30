import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

class CosmicBackground extends StatelessWidget {
  const CosmicBackground({
    super.key,
    required this.child,
    this.decorations = const <Widget>[],
  });

  final Widget child;
  final List<Widget> decorations;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              AppColors.cosmic900,
              AppColors.cosmic800,
              Colors.black,
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            if (decorations.isNotEmpty)
              IgnorePointer(
                child: Stack(fit: StackFit.expand, children: decorations),
              ),
            child,
          ],
        ),
      ),
    );
  }
}
