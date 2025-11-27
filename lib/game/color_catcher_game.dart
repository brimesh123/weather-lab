import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../components/falling_candy.dart';
import '../components/monster.dart';
import '../components/particle.dart';
import '../managers/audio_manager.dart';

class GameColors {
  static const Color red = Color(0xFFFF5252);
  static const Color blue = Color(0xFF448AFF);
  static const Color green = Color(0xFF69F0AE);
  static const Color yellow = Color(0xFFFFD740);
  static const Color purple = Color(0xFFE040FB);
  static const Color orange = Color(0xFFFFAB40);

  static const Map<String, Color> colors = {
    'RED': red,
    'BLUE': blue,
    'GREEN': green,
    'YELLOW': yellow,
    'PURPLE': purple,
    'ORANGE': orange,
  };
  
  static Color lighten(Color c, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(c);
    final hslLight = hsl.withLightness((hsl.lightness + (1 - hsl.lightness) * amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}

class Level {
  final int score;
  final double speed;
  final int spawnRate; // Frames in HTML, we'll use seconds
  final List<String> colors;

  Level({required this.score, required this.speed, required this.spawnRate, required this.colors});
}

class ColorCatcherGame extends FlameGame with PanDetector, HasCollisionDetection {
  late Monster basket;
  late AudioManager audioManager;
  
  int score = 0;
  int lives = 3;
  String targetColorKey = 'RED';
  int levelIndex = 0;
  
  bool isRunning = false;
  bool isGameOver = false;

  double spawnTimer = 0;
  
  final List<Level> levels = [
    Level(score: 0, speed: 200, spawnRate: 60, colors: ['RED', 'BLUE']),
    Level(score: 50, speed: 250, spawnRate: 50, colors: ['RED', 'BLUE', 'GREEN']),
    Level(score: 150, speed: 300, spawnRate: 45, colors: ['RED', 'BLUE', 'GREEN', 'YELLOW']),
    Level(score: 300, speed: 400, spawnRate: 40, colors: ['RED', 'BLUE', 'GREEN', 'YELLOW', 'PURPLE', 'ORANGE']),
  ];

  @override
  Color backgroundColor() => const Color(0xFF87CEEB);

  @override
  Future<void> onLoad() async {
    audioManager = AudioManager();
    await audioManager.init();
    basket = Monster();
    add(basket);
    resetGame();
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    // position the basket near the bottom center
    basket.x = size.x / 2;
    basket.y = size.y - 120;
    // ensure targetX starts centered
    basket.targetX = basket.x;
  }

  void resetGame() {
    score = 0;
    lives = 3;
    levelIndex = 0;
    isGameOver = false;
    isRunning = false;
    children.whereType<FallingCandy>().forEach((c) => c.removeFromParent());
    children.whereType<Particle>().forEach((p) => p.removeFromParent());
    setNewTarget();
    overlays.add('StartMenu');
    overlays.remove('GameOverMenu');
    overlays.add('Hud');
  }

  void startGame() {
    isRunning = true;
    overlays.remove('StartMenu');
    overlays.remove('GameOverMenu');
    audioManager.playMusic();
  }

  void setNewTarget() {
    final level = levels[levelIndex];
    final options = level.colors;
    targetColorKey = options[Random().nextInt(options.length)];
    basket.color = GameColors.colors[targetColorKey]!;
    audioManager.playColorChange();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isRunning || isGameOver) return;
    final level = levels[levelIndex];
    spawnTimer += dt;
    double spawnInterval = level.spawnRate / 60.0;
    if (spawnTimer >= spawnInterval) {
      spawnTimer = 0;
      spawnObject();
    }
    // simple overlap checks between candies and the basket
    final candies = children.whereType<FallingCandy>().toList();
    for (final c in candies) {
      if (!c.isMounted) continue;
      final candyRect = Rect.fromLTWH(c.x - c.size.x / 2, c.y - c.size.y / 2, c.size.x, c.size.y);
      final basketRect = Rect.fromLTWH(basket.x - basket.size.x / 2, basket.y - basket.size.y / 2, basket.size.x, basket.size.y);
      if (candyRect.overlaps(basketRect)) {
        onCatch(c);
      }
    }
  }

  void spawnObject() {
    final level = levels[levelIndex];
    final colorKey = level.colors[Random().nextInt(level.colors.length)];
    final candy = FallingCandy(speed: level.speed + Random().nextDouble() * 50, colorKey: colorKey);
    // place candy at a random x within game bounds
    final minX = candy.size.x / 2 + 20;
    final maxX = size.x - candy.size.x / 2 - 20;
    candy.x = minX + Random().nextDouble() * (maxX - minX);
    candy.y = -candy.size.y;
    add(candy);
  }

  void onCatch(FallingCandy candy) {
    if (candy.colorKey == targetColorKey) {
      score += 10;
      audioManager.playCatch();
      spawnParticles(candy.position, GameColors.colors[candy.colorKey]!);
      if (levelIndex < levels.length - 1 && score >= levels[levelIndex + 1].score) {
        levelIndex++;
        audioManager.playLevelUp();
      }
      if (Random().nextDouble() > 0.7) setNewTarget();
    } else {
      lives--;
      audioManager.playFail();
      // camera.shake may not be available across Flame versions; call dynamically if present
      try {
        (camera as dynamic)?.shake(duration: 0.2, intensity: 5);
      } catch (_) {
        // ignore if shake unavailable
      }
      if (lives <= 0) gameOver();
    }
    candy.removeFromParent();
  }

  void spawnParticles(Vector2 position, Color color) {
    for (int i = 0; i < 10; i++) {
      add(Particle(position: position, color: color));
    }
  }

  void gameOver() {
    isGameOver = true;
    isRunning = false;
    audioManager.stopMusic();
    overlays.add('GameOverMenu');
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (isRunning && !isGameOver) {
      basket.targetX = info.eventPosition.widget.x;
    }
  }
}
