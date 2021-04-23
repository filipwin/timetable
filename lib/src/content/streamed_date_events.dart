import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:time_machine/time_machine.dart';

import '../controller.dart';
import '../event.dart';
import '../timetable.dart';
import 'date_events.dart';

class StreamedDateEvents<E extends Event> extends StatelessWidget {
  const StreamedDateEvents({
    @required this.date,
    @required this.controller,
    @required this.eventBuilder,
    @required this.minHour,
    @required this.maxHour,
  })  : assert(date != null),
        assert(controller != null),
        assert(eventBuilder != null);

  final LocalDate date;
  final TimetableController<E> controller;
  final EventBuilder<E> eventBuilder;

  final int minHour;
  final int maxHour;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<E>>(
      key: ValueKey(date),
      stream: controller.eventProvider.getPartDayEventsIntersecting(date),
      builder: (context, snapshot) {
        final events = snapshot.data ?? [];
        return DateEvents<E>(
          minHour: minHour,
          maxHour: maxHour,
          date: date,
          events: events,
          eventBuilder: eventBuilder,
        );
      },
    );
  }
}
