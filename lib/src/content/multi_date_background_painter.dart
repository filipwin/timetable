import 'package:flutter/widgets.dart';

import '../controller.dart';
import '../event.dart';

class MultiDateBackgroundPainter<E extends Event> extends CustomPainter {
  MultiDateBackgroundPainter({
    @required this.controller,
    @required Color dividerColor,
    this.minHour,
    this.maxHour,
  })  : assert(controller != null),
        assert(dividerColor != null),
        dividerPaint = Paint()..color = dividerColor,
        super(repaint: controller.scrollControllers.pageListenable);

  final TimetableController<E> controller;
  final Paint dividerPaint;
  final int minHour;
  final int maxHour;

  @override
  void paint(Canvas canvas, Size size) {
    _drawDateDividers(canvas, size);
    _drawHourDividers(canvas, size);
  }

  void _drawDateDividers(Canvas canvas, Size size) {
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), dividerPaint);

    final initialOffset = 1 - controller.scrollControllers.page % 1;
    final dateCount = controller.visibleRange.visibleDays;
    final widthPerDate = size.width / dateCount;
    for (var i = 0; i + initialOffset < dateCount; i++) {
      final x = (initialOffset + i) * widthPerDate;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), dividerPaint);
    }
  }

  void _drawHourDividers(Canvas canvas, Size size) {
    final heightPerHour = size.height / (maxHour - minHour);
    for (var h = 0; h < (maxHour - minHour); h++) {
      final y = h * heightPerHour;
      canvas.drawLine(Offset(-8, y), Offset(size.width, y), dividerPaint);
    }
  }

  @override
  bool shouldRepaint(MultiDateBackgroundPainter oldDelegate) =>
      dividerPaint.color != oldDelegate.dividerPaint.color;
}
