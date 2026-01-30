import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CosmicPrimaryButton extends StatefulWidget {
  const CosmicPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailing,
  });

  final String label;
  final VoidCallback onPressed;
  final Widget? trailing;

  @override
  State<CosmicPrimaryButton> createState() => _CosmicPrimaryButtonState();
}

class _CosmicPrimaryButtonState extends State<CosmicPrimaryButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final background = AppColors.mysticPurple.withValues(alpha: _pressed ? 0.40 : 0.20);
    final border = AppColors.mysticPurple.withValues(alpha: 0.50);
    final shadowColor = AppColors.mysticPurple.withValues(alpha: _pressed ? 0.40 : 0.0);

    return AnimatedScale(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      scale: _pressed ? 1.04 : 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: ShapeDecoration(
          color: background,
          shape: StadiumBorder(side: BorderSide(color: border)),
          shadows: <BoxShadow>[
            BoxShadow(
              color: shadowColor,
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: widget.onPressed,
            onTapDown: (_) => _setPressed(true),
            onTapCancel: () => _setPressed(false),
            onTapUp: (_) => _setPressed(false),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(widget.label),
                  if (widget.trailing != null) ...<Widget>[
                    const SizedBox(width: 8),
                    widget.trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
