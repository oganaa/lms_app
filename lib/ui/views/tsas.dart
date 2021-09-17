import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyCanvas());
}

class MyCanvas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<SnowFlake> snowflakes = List.generate(100, (index) => SnowFlake());
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.lightBlue, Colors.white],
            stops: [0, 0.7, 0.95],
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            snowflakes.forEach((snow) => snow.fall());
            return CustomPaint(
              painter: MyPainter(snowflakes),
            );
          },
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final List<SnowFlake> snowflakes;

  MyPainter(this.snowflakes);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final c = size.center(Offset.zero);

    final whitePaint = Paint()..color = Colors.white;

    canvas.drawCircle(c - Offset(0, -h * 0.165), w / 6, whitePaint);
    canvas.drawOval(
        Rect.fromCenter(
          center: c - Offset(0, -h * 0.35),
          width: w * 0.5,
          height: w * 0.6,
        ),
        whitePaint);

    snowflakes.forEach((snow) =>
        canvas.drawCircle(Offset(snow.x, snow.y), snow.radius, whitePaint));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class SnowFlake {
  double x = Random().nextDouble() * 400;
  double y = Random().nextDouble() * 800;
  double radius = Random().nextDouble() * 2 + 2;
  double velocity = Random().nextDouble() * 4 + 2;

  SnowFlake();

  fall() {
    y += velocity;
    if (y > 800) {
      x = Random().nextDouble() * 400;
      y = 10;
      radius = Random().nextDouble() * 2 + 2;
      velocity = Random().nextDouble() * 4 + 2;
    }
  }
}