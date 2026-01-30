import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/kundali_chart.dart';

class NorthIndianKundaliChart extends StatelessWidget {
  const NorthIndianKundaliChart({super.key, required this.data});

  final KundaliChartData data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final s = size.shortestSide;
        return Center(
          child: SizedBox(
            width: s,
            height: s,
            child: CustomPaint(painter: _NorthIndianKundaliPainter(data: data)),
          ),
        );
      },
    );
  }
}

class _NorthIndianKundaliPainter extends CustomPainter {
  const _NorthIndianKundaliPainter({required this.data});

  final KundaliChartData data;

  static const _designSize = 400.0;

  static const List<_HouseLayout> _houseLayouts = <_HouseLayout>[
    _HouseLayout(house: 1, planet: Offset(200, 90), sign: Offset(200, 175)),
    _HouseLayout(house: 2, planet: Offset(100, 40), sign: Offset(100, 90)),
    _HouseLayout(house: 3, planet: Offset(40, 100), sign: Offset(90, 100)),
    _HouseLayout(house: 4, planet: Offset(100, 200), sign: Offset(165, 200)),
    _HouseLayout(house: 5, planet: Offset(40, 300), sign: Offset(90, 300)),
    _HouseLayout(house: 6, planet: Offset(100, 360), sign: Offset(100, 310)),
    _HouseLayout(house: 7, planet: Offset(200, 310), sign: Offset(200, 225)),
    _HouseLayout(house: 8, planet: Offset(300, 360), sign: Offset(300, 310)),
    _HouseLayout(house: 9, planet: Offset(360, 300), sign: Offset(310, 300)),
    _HouseLayout(house: 10, planet: Offset(300, 200), sign: Offset(235, 200)),
    _HouseLayout(house: 11, planet: Offset(360, 100), sign: Offset(310, 100)),
    _HouseLayout(house: 12, planet: Offset(300, 40), sign: Offset(300, 90)),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final offset = Offset((size.width - s) / 2, (size.height - s) / 2);
    final rect = offset & Size(s, s);

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = mathMax(1.0, s * 0.004)
      ..color = AppColors.mysticGold.withValues(alpha: 0.70);

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = mathMax(1.0, s * 0.0035)
      ..color = AppColors.mysticGold.withValues(alpha: 0.55);

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.cosmic800.withValues(alpha: 0.35);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(s * 0.04)),
      fillPaint,
    );

    canvas.drawRect(rect.deflate(s * 0.02), borderPaint);

    final inner = rect.deflate(s * 0.02);

    final tl = inner.topLeft;
    final tr = inner.topRight;
    final bl = inner.bottomLeft;
    final br = inner.bottomRight;

    final mt = Offset(inner.center.dx, inner.top);
    final mb = Offset(inner.center.dx, inner.bottom);
    final ml = Offset(inner.left, inner.center.dy);
    final mr = Offset(inner.right, inner.center.dy);

    canvas.drawLine(tl, br, linePaint);
    canvas.drawLine(tr, bl, linePaint);

    canvas.drawLine(mt, ml, linePaint);
    canvas.drawLine(ml, mb, linePaint);
    canvas.drawLine(mb, mr, linePaint);
    canvas.drawLine(mr, mt, linePaint);

    _paintHouses(canvas, inner);
  }

  void _paintHouses(Canvas canvas, Rect rect) {
    final scale = rect.width / _designSize;
    final signBadgeSize = mathMax(18.0, 20.0 * scale);

    for (final layout in _houseLayouts) {
      final house = data.houses[layout.house - 1];

      final signPos =
          rect.topLeft + Offset(layout.sign.dx, layout.sign.dy) * scale;
      _paintSignBadge(canvas, signPos, house.sign.shortName, signBadgeSize);

      final planetPos =
          rect.topLeft + Offset(layout.planet.dx, layout.planet.dy) * scale;
      _paintPlanets(canvas, planetPos, house.planets, scale);
    }
  }

  void _paintSignBadge(Canvas canvas, Offset center, String text, double size) {
    final r = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: size, height: size),
      Radius.circular(size * 0.22),
    );
    final fill = Paint()
      ..color = AppColors.mysticPurple.withValues(alpha: 0.25);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = AppColors.mysticPurple.withValues(alpha: 0.55);

    canvas.drawRRect(r, fill);
    canvas.drawRRect(r, stroke);

    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.inter(
          fontSize: size * 0.48,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFE9D5FF),
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 1,
    )..layout(minWidth: 0, maxWidth: size);

    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  void _paintPlanets(
    Canvas canvas,
    Offset center,
    List<KundaliPlanet> planets,
    double scale,
  ) {
    if (planets.isEmpty) return;

    final base = mathMax(10.0, 12.0 * scale);
    final spacingX = mathMax(16.0, 20.0 * scale);
    final spacingY = mathMax(12.0, 16.0 * scale);

    for (var i = 0; i < planets.length; i++) {
      final p = planets[i];
      final offset = _planetOffset(i, planets.length, spacingX, spacingY);
      final text = p.isRetrograde ? '${p.id.abbr}R' : p.id.abbr;

      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: GoogleFonts.inter(
            fontSize: base,
            fontWeight: FontWeight.w600,
            color: _planetColor(p.id),
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();

      tp.paint(canvas, center + offset - Offset(tp.width / 2, tp.height / 2));
    }
  }

  Offset _planetOffset(int i, int count, double sx, double sy) {
    if (count == 1) return Offset.zero;
    if (count == 2) return Offset((i == 0 ? -1 : 1) * sx * 0.4, 0);
    if (count == 3) {
      return switch (i) {
        0 => Offset(0, -sy * 0.5),
        1 => Offset(-sx * 0.5, sy * 0.5),
        _ => Offset(sx * 0.5, sy * 0.5),
      };
    }

    final col = i % 2;
    final row = i ~/ 2;
    final dx = (col == 0 ? -1 : 1) * sx * 0.5;
    final dy = (row - 0.5) * sy;
    return Offset(dx, dy);
  }

  Color _planetColor(PlanetId id) {
    return switch (id) {
      PlanetId.sun || PlanetId.moon || PlanetId.mars => AppColors.mysticGold,
      _ => Colors.white,
    };
  }

  @override
  bool shouldRepaint(covariant _NorthIndianKundaliPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}

class _HouseLayout {
  const _HouseLayout({
    required this.house,
    required this.planet,
    required this.sign,
  });

  final int house;
  final Offset planet;
  final Offset sign;
}

double mathMax(double a, double b) => a > b ? a : b;
