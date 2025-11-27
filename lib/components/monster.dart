import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class Monster extends PositionComponent {
  late Paint _paint;
  double targetX = 0;

  Monster() : super(size: Vector2(140, 70), anchor: Anchor.center);

  set color(Color c) {
    _paint = Paint()..color = c;
  }

  @override
  Future<void> onLoad() async {
    // position will be adjusted by the game after load
    _paint = Paint()..color = Colors.purple;
    await super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = size.toRect();
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(14)), _paint);

    // eyes
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(20, size.y / 2 - 8), 10, eyePaint);
    canvas.drawCircle(Offset(size.x - 20, size.y / 2 - 8), 10, eyePaint);

    // pupils
    final pupil = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(20, size.y / 2 - 6), 4, pupil);
    canvas.drawCircle(Offset(size.x - 20, size.y / 2 - 6), 4, pupil);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Smoothly follow targetX
    final dx = targetX - x;
    x += dx * (0.15 + dt * 5);
  }
}
