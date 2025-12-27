import 'package:flutter/material.dart';
import 'package:movigo/data/services/connectivity_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class NoWifiPage extends StatefulWidget {
  final VoidCallback? onRetry;
  
  const NoWifiPage({super.key, this.onRetry});

  @override
  State<NoWifiPage> createState() => _NoWifiPageState();
}

// WiFi sinyali yayı için özel widget
class WifiArc extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color color;
  final double startAngle; // Radyan cinsinden başlangıç açısı
  final double sweepAngle; // Radyan cinsinden açı uzunluğu

  const WifiArc({
    super.key,
    required this.size,
    this.strokeWidth = 3.0,
    required this.color,
    this.startAngle = -math.pi / 6, // Varsayılan: -30 derece
    this.sweepAngle = math.pi / 3, // Varsayılan: 60 derece
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _WifiArcPainter(
        color: color,
        strokeWidth: strokeWidth,
        startAngle: startAngle,
        sweepAngle: sweepAngle,
      ),
    );
  }
}

class _WifiArcPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double startAngle;
  final double sweepAngle;

  _WifiArcPainter({
    required this.color,
    required this.strokeWidth,
    required this.startAngle,
    required this.sweepAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Kalın X işareti çizen özel widget
class ThickCrossIcon extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color color;
  final List<Shadow>? shadows;

  const ThickCrossIcon({
    super.key,
    required this.size,
    required this.strokeWidth,
    required this.color,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CrossPainter(
        color: color,
        strokeWidth: strokeWidth,
        shadows: shadows,
      ),
    );
  }
}

class _CrossPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final List<Shadow>? shadows;

  _CrossPainter({required this.color, required this.strokeWidth, this.shadows});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Shadow çizimi
    final shadowList = shadows;
    if (shadowList != null) {
      for (final shadow in shadowList) {
        final shadowPaint = Paint()
          ..color = shadow.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.blurRadius);

        // Sol üstten sağ alta çizgi (shadow)
        canvas.drawLine(
          Offset(size.width * 0.2, size.height * 0.2) + shadow.offset,
          Offset(size.width * 0.8, size.height * 0.8) + shadow.offset,
          shadowPaint,
        );

        // Sağ üstten sol alta çizgi (shadow)
        canvas.drawLine(
          Offset(size.width * 0.8, size.height * 0.2) + shadow.offset,
          Offset(size.width * 0.2, size.height * 0.8) + shadow.offset,
          shadowPaint,
        );
      }
    }

    // Sol üstten sağ alta çizgi
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.8),
      paint,
    );

    // Sağ üstten sol alta çizgi
    canvas.drawLine(
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width * 0.2, size.height * 0.8),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NoWifiPageState extends State<NoWifiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Stack(
                fit: StackFit.loose,
                children: [
                  // Örnek kullanımlar - farklı boyutlarda ve pozisyonlarda wifi yayları
                  Positioned(
                    left: -20,
                    top: 260,
                    child: WifiArc(
                      size: 150,
                      strokeWidth: 16,
                      startAngle: -math.pi / 1.3,
                      sweepAngle: math.pi / 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Positioned(
                    left: -40,
                    top: 210,
                    child: WifiArc(
                      size: 150,
                      strokeWidth: 16,
                      startAngle: -math.pi / 1.2,
                      sweepAngle: math.pi / 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Positioned(
                    left: -35,
                    top: 160,
                    child: WifiArc(
                      size: 150,
                      strokeWidth: 16,
                      startAngle: -math.pi / 1.2,
                      sweepAngle: math.pi / 1.8,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  Positioned(
                    left: 120,
                    top: 150,
                    child: ThickCrossIcon(
                      size: 150,
                      strokeWidth: 18, // Kalınlığı buradan ayarlayabilirsiniz
                      color: Theme.of(context).colorScheme.primary,
                      shadows: [
                        Shadow(
                          blurRadius: 8.0,
                          color: Colors.black26,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    left: 10,
                    top: 280,
                    child: Text(
                      "Ooops!",
                      style: TextStyle(
                        fontSize: 110,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "No Internet Connection",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "An internet connection is required to access the content in the application. Please check your internet connection and try again.",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      // Önce custom callback varsa çağır
                      widget.onRetry?.call();
                      
                      // ConnectivityProvider üzerinden bağlantıyı kontrol et
                      final connectivityProvider = context.read<ConnectivityProvider>();
                      await connectivityProvider.retryConnection();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
