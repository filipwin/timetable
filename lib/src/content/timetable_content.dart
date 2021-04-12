import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/widgets.dart';

import '../controller.dart';
import '../event.dart';
import '../theme.dart';
import '../timetable.dart';
import '../utils/vertical_zoom.dart';
import 'date_hours_painter.dart';
import 'multi_date_content.dart';

class TimetableContent<E extends Event> extends StatelessWidget {
  const TimetableContent({
    Key key,
    @required this.controller,
    @required this.eventBuilder,
    this.onEventBackgroundTap,
    this.minHour,
    this.maxHour,
  })  : assert(controller != null),
        assert(eventBuilder != null),
        super(key: key);

  final TimetableController<E> controller;
  final EventBuilder<E> eventBuilder;
  final OnEventBackgroundTapCallback onEventBackgroundTap;

  final int minHour;
  final int maxHour;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final timetableTheme = context.timetableTheme;

    return VerticalZoom(
      initialZoom: controller.initialTimeRange.asInitialZoom(),
      minChildHeight:
          (timetableTheme?.minimumHourHeight ?? 16) * (maxHour - minHour),
      maxChildHeight:
          (timetableTheme?.maximumHourHeight ?? 64) * (maxHour - minHour),
      child: Row(
        children: <Widget>[
          Container(
            width: hourColumnWidth,
            padding: EdgeInsets.only(right: 12),
            child: CustomPaint(
              painter: DateHoursPainter(
                minHour: minHour,
                maxHour: maxHour,
                textStyle: timetableTheme?.hourTextStyle ??
                    theme.textTheme.caption.copyWith(
                      color: context.theme.disabledOnBackground,
                    ),
                textDirection: context.directionality,
              ),
              size: Size.infinite,
            ),
          ),
          Expanded(
            child: MultiDateContent<E>(
              minHour: minHour,
              maxHour: maxHour,
              controller: controller,
              eventBuilder: eventBuilder,
              onEventBackgroundTap: onEventBackgroundTap,
            ),
          ),
        ],
      ),
    );
  }
}
