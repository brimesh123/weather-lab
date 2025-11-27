import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class Particle extends PositionComponent {
  late Paint _paint;
  double life = 1.0;
  Vector2 velocity = Vector2.zero();

  Particle({required Vector2 position, required Color color}) : super(size: Vector2.all(6), anchor: Anchor.center) {
    this.position = position.clone();
    _paint = Paint()..color = color;
    velocity = Vector2((-1 + (2 * (DateTime.now().millisecond % 100) / 100)) * 100, -50 - (DateTime.now().millisecond % 100) / 2);
  }

  @override
  void update(double dt) {
    super.update(dt);
    life -= dt * 1.8;
    if (life <= 0) removeFromParent();
    y += velocity.y * dt;
    x += velocity.x * dt;
    final alpha = (life.clamp(0.0, 1.0) * 255).round();
    _paint.color = _paint.color.withAlpha(alpha);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, _paint);
  }
}
