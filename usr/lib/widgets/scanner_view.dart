import 'package:flutter/material.dart';

class ScannerView extends StatefulWidget {
  final bool isScanning;
  final String? prediction;

  const ScannerView({
    super.key,
    required this.isScanning,
    this.prediction,
  });

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.isScanning) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ScannerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScanning && !oldWidget.isScanning) {
      _animationController.repeat(reverse: true);
    } else if (!widget.isScanning && oldWidget.isScanning) {
      _animationController.stop();
      _animationController.value = 0.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isScanning 
              ? const Color(0xFF00C853) 
              : (widget.prediction == 'DOWN' ? const Color(0xFFD50000) : Colors.grey.withOpacity(0.3)),
          width: widget.isScanning ? 2 : 1,
        ),
        boxShadow: widget.isScanning
            ? [
                BoxShadow(
                  color: const Color(0xFF00C853).withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Mock Camera Feed / Chart Background
            CustomPaint(
              painter: GridPainter(),
            ),
            
            // Center Target Icon
            Center(
              child: Icon(
                Icons.center_focus_weak,
                size: 100,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            
            // Instructions
            if (!widget.isScanning && widget.prediction == null)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white.withOpacity(0.5), size: 40),
                    const SizedBox(height: 8),
                    Text(
                      'Point camera at Quotex chart',
                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                  ],
                ),
              ),

            // Scanning Animation Line
            if (widget.isScanning)
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Positioned(
                    top: _animation.value * (MediaQuery.of(context).size.height * 0.4),
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C853),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00C853).withOpacity(0.8),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            // Prediction Overlay
            if (widget.prediction != null)
              Container(
                color: widget.prediction == 'UP' 
                    ? const Color(0xFF00C853).withOpacity(0.2)
                    : const Color(0xFFD50000).withOpacity(0.2),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.prediction == 'UP' ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 80,
                        color: widget.prediction == 'UP' ? const Color(0xFF00C853) : const Color(0xFFD50000),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${widget.prediction} TREND DETECTED',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: widget.prediction == 'UP' ? const Color(0xFF00C853) : const Color(0xFFD50000),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Painter for the mock chart grid background
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.05)
      ..strokeWidth = 1;

    // Draw vertical lines
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Draw horizontal lines
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
    
    // Draw a mock chart line
    final chartPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
      
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.9, size.width * 0.4, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.2, size.width * 0.8, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.5, size.width, size.height * 0.3);
    
    canvas.drawPath(path, chartPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
