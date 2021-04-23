import 'dart:ui';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart' hide Offset;
import 'package:timetable/src/utils/utils.dart';

import '../controller.dart';
import '../event.dart';

class CurrentTimeIndicatorPainter<E extends Event> extends CustomPainter {
  CurrentTimeIndicatorPainter({
    @required this.controller,
    @required Color color,
    @required this.minHour,
    @required this.maxHour,
    this.circleRadius = 4,
    Listenable repaint,
  })  : assert(controller != null),
        assert(color != null),
        _paint = Paint()..color = color,
        assert(circleRadius != null),
        super(
          repaint: Listenable.merge([
            controller.scrollControllers.pageListenable,
            repaint,
          ]),
        );

  final TimetableController<E> controller;
  final Paint _paint;
  final double circleRadius;

  final int minHour;
  final int maxHour;

  @override
  void paint(Canvas canvas, Size size) {
    final dateWidth = size.width / controller.visibleRange.visibleDays;

    final temporalOffset =
        LocalDate.today().epochDay - controller.scrollControllers.page;
    final left = temporalOffset * dateWidth;
    final right = left + dateWidth;

    if (right < 0 || left > size.width) {
      // The current date isn't visible so we don't have to paint anything.
      return;
    }

    final actualLeft = left.coerceAtLeast(0);
    final actualRight = right.coerceAtMost(size.width);

    final nowNs = LocalTime.currentClockTime().timeSinceMidnight;
    final rangeStartNs = localTimeHour(minHour).timeSinceMidnight;
    final rangeEndNs = localTimeHour(maxHour).timeSinceMidnight;
    final nsFromStart = nowNs - rangeStartNs;
    final nsInRange = (rangeEndNs - rangeStartNs);

    if (nowNs >= rangeStartNs && nowNs <= rangeEndNs) {
      final y = (nsFromStart.inSeconds / nsInRange.inSeconds) * size.height;

      final radius = lerpDouble(circleRadius, 0, (actualLeft - left) / dateWidth);
      canvas
        ..drawCircle(Offset(actualLeft, y), radius, _paint)
        ..drawLine(
            Offset(actualLeft + radius, y), Offset(actualRight, y), _paint);
    }
  }

  @override
  bool shouldRepaint(CurrentTimeIndicatorPainter oldDelegate) =>
      _paint.color != oldDelegate._paint.color ||
      circleRadius != oldDelegate.circleRadius;
}
