import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ExpencyLogoWidget extends StatelessWidget {
  const ExpencyLogoWidget({
    super.key,
    this.size = 80,
    this.showGlow = true,
  });

  final double size;
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        borderRadius: BorderRadius.circular(size * 0.25),
        border: Border.all(
          color: kPrimary.withValues(alpha: 0.45),
          width: 1.5,
        ),
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: glowColor(kPrimary, 0.4),
                  blurRadius: size * 0.35,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: CustomPaint(
        painter: _ExpencyLogoPainter(primaryColor: kPrimary, accentGreen: kIncome),
      ),
    );
  }
}

class _ExpencyLogoPainter extends CustomPainter {
  const _ExpencyLogoPainter({
    required this.primaryColor,
    required this.accentGreen,
  });

  final Color primaryColor;
  final Color accentGreen;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryColor, const Color(0xFF00808A)],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    // Draw stylized 'E'
    final path = Path();
    final left = w * 0.28;
    final right = w * 0.72;
    final top = h * 0.28;
    final bottom = h * 0.72;
    final thickness = w * 0.12;

    // Outer boundary of E
    path.moveTo(left, top);
    path.lineTo(right, top);
    path.lineTo(right, top + thickness);
    path.lineTo(left + thickness, top + thickness);
    path.lineTo(left + thickness, h * 0.44);
    path.lineTo(w * 0.62, h * 0.44);
    path.lineTo(w * 0.62, h * 0.44 + thickness);
    path.lineTo(left + thickness, h * 0.44 + thickness);
    path.lineTo(left + thickness, bottom - thickness);
    path.lineTo(right, bottom - thickness);
    path.lineTo(right, bottom);
    path.lineTo(left, bottom);
    path.close();

    canvas.drawPath(path, paint);

    // Live dot indicator
    final dotPaint = Paint()
      ..color = accentGreen
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.72, h * 0.50), w * 0.05, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _ExpencyLogoPainter oldDelegate) =>
      oldDelegate.primaryColor != primaryColor || oldDelegate.accentGreen != accentGreen;
}
