import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class FallingCandy extends PositionComponent {
  final double speed;
  final String colorKey;
  late Paint _paint;

  static const Map<String, Color> _colors = {
    'RED': Color(0xFFFF5252),
    'BLUE': Color(0xFF448AFF),
    'GREEN': Color(0xFF69F0AE),
    'YELLOW': Color(0xFFFFD740),
    'PURPLE': Color(0xFFE040FB),
    'ORANGE': Color(0xFFFFAB40),
  };

  FallingCandy({required this.speed, required this.colorKey}) : super(size: Vector2.all(28), anchor: Anchor.center) {
    _paint = Paint()..color = _colors[colorKey] ?? Colors.white;
  }

  @override
  void update(double dt) {
    super.update(dt);
    y += speed * dt;
    double parentHeight = 1000;
    try {
      if (parent is FlameGame) {
        parentHeight = (parent as FlameGame).size.y;
      } else if (parent is PositionComponent) {
        parentHeight = (parent as PositionComponent).size.y;
      }
    } catch (_) {}
    if (y > parentHeight + size.y) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, _paint);
    // simple highlight
    final highlight = Paint()..color = const Color.fromRGBO(255, 255, 255, 0.2);
    canvas.drawCircle(Offset(size.x / 2 - 4, size.y / 2 - 6), 5, highlight);
  }
}
