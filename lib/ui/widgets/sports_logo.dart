import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// SportsAadhaar Logo widget - displays the sun with running athlete
class SportsLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool animated;

  const SportsLogo({
    super.key,
    this.size = 120,
    this.showText = false,
    this.animated = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo using custom paint for better control
        CustomPaint(
          size: Size(size, size),
          painter: _LogoPainter(),
        ),
        if (showText) ...[
          const SizedBox(height: 16),
          Text(
            'SportsAadhaar',
            style: TextStyle(
              fontSize: size * 0.22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Draw sun rays
    final rayPaint = Paint()
      ..color = AppTheme.primaryOrange
      ..style = PaintingStyle.fill;
    
    const rayCount = 16;
    for (int i = 0; i < rayCount; i++) {
      final angle = (i * 360 / rayCount) * 3.14159 / 180;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      
      // Alternate between long and short rays
      final isLongRay = i % 2 == 0;
      final rayLength = isLongRay ? radius * 0.95 : radius * 0.8;
      final rayWidth = isLongRay ? radius * 0.12 : radius * 0.08;
      
      final path = Path();
      path.moveTo(0, -radius * 0.4);
      path.lineTo(-rayWidth / 2, -rayLength);
      path.lineTo(rayWidth / 2, -rayLength);
      path.close();
      
      canvas.drawPath(path, rayPaint);
      canvas.restore();
    }
    
    // Draw white circle
    final circlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.45, circlePaint);
    
    // Draw running athlete figure
    final athletePaint = Paint()
      ..color = AppTheme.secondaryPurple
      ..style = PaintingStyle.fill;
    
    final figureCenter = center;
    final figureScale = radius * 0.006;
    
    // Head
    canvas.drawCircle(
      Offset(figureCenter.dx + 12 * figureScale, figureCenter.dy - 25 * figureScale),
      7 * figureScale,
      athletePaint,
    );
    
    // Body curve
    final bodyPath = Path();
    bodyPath.moveTo(figureCenter.dx + 5 * figureScale, figureCenter.dy - 18 * figureScale);
    bodyPath.quadraticBezierTo(
      figureCenter.dx - 8 * figureScale, figureCenter.dy - 5 * figureScale,
      figureCenter.dx - 18 * figureScale, figureCenter.dy + 8 * figureScale,
    );
    bodyPath.quadraticBezierTo(
      figureCenter.dx - 25 * figureScale, figureCenter.dy + 18 * figureScale,
      figureCenter.dx - 28 * figureScale, figureCenter.dy + 28 * figureScale,
    );
    bodyPath.lineTo(figureCenter.dx - 22 * figureScale, figureCenter.dy + 30 * figureScale);
    bodyPath.quadraticBezierTo(
      figureCenter.dx - 15 * figureScale, figureCenter.dy + 18 * figureScale,
      figureCenter.dx - 5 * figureScale, figureCenter.dy + 5 * figureScale,
    );
    bodyPath.quadraticBezierTo(
      figureCenter.dx + 8 * figureScale, figureCenter.dy - 8 * figureScale,
      figureCenter.dx + 12 * figureScale, figureCenter.dy - 15 * figureScale,
    );
    bodyPath.close();
    canvas.drawPath(bodyPath, athletePaint);
    
    // Arm sweep
    final armPath = Path();
    armPath.moveTo(figureCenter.dx - 2 * figureScale, figureCenter.dy - 8 * figureScale);
    armPath.quadraticBezierTo(
      figureCenter.dx - 18 * figureScale, figureCenter.dy - 22 * figureScale,
      figureCenter.dx - 25 * figureScale, figureCenter.dy - 25 * figureScale,
    );
    armPath.quadraticBezierTo(
      figureCenter.dx - 28 * figureScale, figureCenter.dy - 22 * figureScale,
      figureCenter.dx - 22 * figureScale, figureCenter.dy - 18 * figureScale,
    );
    armPath.quadraticBezierTo(
      figureCenter.dx - 12 * figureScale, figureCenter.dy - 12 * figureScale,
      figureCenter.dx - 5 * figureScale, figureCenter.dy - 5 * figureScale,
    );
    armPath.close();
    canvas.drawPath(armPath, athletePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Simple text logo without icon
class SportsLogoText extends StatelessWidget {
  final double fontSize;
  final Color? color;

  const SportsLogoText({
    super.key,
    this.fontSize = 28,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'SportsAadhaar',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color ?? AppTheme.textPrimary,
        letterSpacing: 0.5,
      ),
    );
  }
}

