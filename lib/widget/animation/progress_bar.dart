import 'dart:math';
import 'package:flutter/material.dart';

class ExplicitAnimationDemo extends StatefulWidget {
  @override
  _ExplicitAnimationDemoState createState() => _ExplicitAnimationDemoState();
}

// 必须混入 SingleTickerProviderStateMixin
class _ExplicitAnimationDemoState extends State<ExplicitAnimationDemo>
    with SingleTickerProviderStateMixin {
  // 1. 定义动画控制器
  late AnimationController _controller;
  // 2. 定义动画对象
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // 初始化控制器，设置动画时长
    _controller = AnimationController(
      vsync: this, // 必需的 vsync 参数
      duration: Duration(seconds: 3),
    );
    // 使用 Tween 将 0.0-1.0 的值映射给 _animation
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    // 启动动画
    _controller.repeat();
  }

  @override
  void dispose() {
    // 销毁控制器，防止内存泄漏
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('显式动画: AnimationController')),
      body: Center(
        // 3. 使用 AnimatedBuilder 来构建动画UI
        child: AnimatedBuilder(
          animation: _animation, // 监听动画
          builder: (context, child) {
            return CustomPaint(
              // 传入自定义的画笔
              painter: _CirclePainter(_animation.value),
              size: Size(100, 100),
            );
          },
        ),
      ),
    );
  }
}

// 自定义画笔，用于绘制圆形进度条
class _CirclePainter extends CustomPainter {
  final double progress;

  _CirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke;

    final Offset center = size.center(Offset.zero);
    final double radius = size.width / 2 - paint.strokeWidth / 2;

    // 绘制背景圆环
    canvas.drawCircle(center, radius, paint);

    // 绘制进度圆弧
    paint.color = Colors.blue;
    final double sweepAngle = progress * 2 * pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // 从顶部开始
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 每次都重绘
  }
}
