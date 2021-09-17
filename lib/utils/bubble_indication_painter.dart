import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class TabIndicationPainter extends CustomPainter {
  Paint painter;
   double dxTarget;
   double dxEntry;
   double radius;
   double dy;

  final PageController pageController;

  TabIndicationPainter(
      {this.dxTarget = 135.0,
        this.dxEntry = 15.0,
        this.radius = 25.0,
        this.dy = 25.0, this.pageController}) : super(repaint: pageController) {
    painter = new Paint()
      ..color = Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.dxTarget = ScreenUtil().setWidth(235);
    this.dxEntry = ScreenUtil().setWidth(35);
    this.radius = ScreenUtil().setHeight(35);
    this.dy = ScreenUtil().setHeight(36);
    final pos = pageController.position;
    double fullExtent = (pos.maxScrollExtent - pos.minScrollExtent + pos.viewportDimension);

    double pageOffset = pos.extentBefore / fullExtent;

    bool left2right = dxEntry < dxTarget;
    Offset entry = new Offset(left2right ? dxEntry: dxTarget, dy);
    Offset target = new Offset(left2right ? dxTarget : dxEntry, dy);

    Path path = new Path();
    path.addArc(
        new Rect.fromCircle(center: entry, radius: radius), 0.5 * pi, 1 * pi);
    path.addRect(
        new Rect.fromLTRB(entry.dx, dy - radius, target.dx, dy + radius));
    path.addArc(
        new Rect.fromCircle(center: target, radius: radius), 1.5 * pi, 1 * pi);

    canvas.translate(size.width * pageOffset, 0.0);
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(TabIndicationPainter oldDelegate) => true;
}