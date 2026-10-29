import 'package:flutter/material.dart';

class HeroCard3D extends StatefulWidget {
  final Widget child;
  final double height;
  final double borderRadius;
  final VoidCallback? onTap;

  const HeroCard3D({
    super.key,
    required this.child,
    this.height = 180,
    this.borderRadius = 24,
    this.onTap,
  });

  @override
  State<HeroCard3D> createState() => _HeroCard3DState();
}

class _HeroCard3DState extends State<HeroCard3D> with SingleTickerProviderStateMixin {
  double _rotateX = 0.0;
  double _rotateY = 0.0;
  Offset _pointerPos = Offset.zero;
  bool _isHovering = false;

  late AnimationController _resetController;
  late Animation<double> _animX;
  late Animation<double> _animY;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _resetController.addListener(() {
      setState(() {
        _rotateX = _animX.value;
        _rotateY = _animY.value;
      });
    });
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent event, BoxConstraints constraints) {
    final size = Size(constraints.maxWidth, widget.height);
    final dx = (event.localPosition.dx / size.width) - 0.5;
    final dy = (event.localPosition.dy / size.height) - 0.5;

    setState(() {
      _rotateY = dx * 0.25; // max tilt rad
      _rotateX = -dy * 0.25;
      _pointerPos = event.localPosition;
      _isHovering = true;
    });
  }

  void _onExit([PointerEvent? _]) {
    _animX = Tween<double>(begin: _rotateX, end: 0.0).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeOutBack),
    );
    _animY = Tween<double>(begin: _rotateY, end: 0.0).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeOutBack),
    );
    _resetController.forward(from: 0.0);
    setState(() => _isHovering = false);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          onHover: (e) => _onHover(e, constraints),
          onExit: _onExit,
          child: GestureDetector(
            onTap: widget.onTap,
            onPanUpdate: (details) {
              final size = Size(constraints.maxWidth, widget.height);
              final dx = (details.localPosition.dx / size.width) - 0.5;
              final dy = (details.localPosition.dy / size.height) - 0.5;
              setState(() {
                _rotateY = dx.clamp(-0.5, 0.5) * 0.3;
                _rotateX = -dy.clamp(-0.5, 0.5) * 0.3;
                _pointerPos = details.localPosition;
                _isHovering = true;
              });
            },
            onPanEnd: (_) => _onExit(),
            child: Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_rotateX)
                ..rotateY(_rotateY),
              child: Stack(
                children: [
                  // Main Content
                  widget.child,

                  // Moving Dynamic Specular Glare Layer
                  if (_isHovering)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(widget.borderRadius),
                        child: CustomPaint(
                          painter: _GlarePainter(
                            glarePosition: _pointerPos,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GlarePainter extends CustomPainter {
  final Offset glarePosition;

  _GlarePainter({required this.glarePosition});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          (glarePosition.dx / size.width) * 2 - 1,
          (glarePosition.dy / size.height) * 2 - 1,
        ),
        radius: 0.7,
        colors: [
          Colors.white.withValues(alpha: 0.22),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _GlarePainter oldDelegate) {
    return oldDelegate.glarePosition != glarePosition;
  }
}
