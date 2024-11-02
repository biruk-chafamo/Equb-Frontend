import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_state.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/tiles/section_title_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'package:intl/intl.dart';

final today = DateTime.now();
final firstDay = DateTime(today.year, today.month - 3, today.day);
final lastDay = DateTime(today.year, today.month + 5, today.day);

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

class UpcomingRoundCalander extends StatelessWidget {
  const UpcomingRoundCalander({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EqubBloc, EqubDetailState>(
      builder: (context, state) {
        if (state.status != EqubDetailStatus.success) {
          return CalanderBody(events: LinkedHashMap<DateTime, List<Event>>());
        } else {
          final eventSource = <DateTime, List<Event>>{
            for (var winDate in state.equbDetail?.paymentCollectionDates ?? [])
              winDate: List.generate(
                  1, (index) => Event('Event $winDate | ${index + 1}'))
          };

          final events = LinkedHashMap<DateTime, List<Event>>(
            equals: isSameDay,
            hashCode: getHashCode,
          )..addAll(eventSource);
          return CalanderBody(events: events);
        }
      },
    );
  }
}

class CalanderBody extends StatefulWidget {
  final LinkedHashMap<DateTime, List<Event>> events;
  const CalanderBody({super.key, required this.events});

  @override
  CalanderBodyState createState() => CalanderBodyState();
}

class CalanderBodyState extends State<CalanderBody> {
  final ValueNotifier<List<Event>> _selectedEvents = ValueNotifier([]);

  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return widget.events[day] ?? [];
  }

  DateTime _focusedDay = DateTime.now();
  final _firstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  final _lastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 5, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionTitleTile(
              "Next Round Payment",
              Icons.calendar_month,
              Text(" "),
              includeDivider: false,
            ),
            Padding(
              padding: AppPadding.globalPadding,
              child: Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat.MMMM().format(_focusedDay),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      DateFormat.y().format(_focusedDay),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        TableCalendar<Event>(
          firstDay: _firstDay,
          lastDay: _lastDay,
          focusedDay: widget.events.isEmpty ? DateTime.now() : widget.events.keys.first,
          calendarFormat: _calendarFormat,
          daysOfWeekStyle: DaysOfWeekStyle(
            dowTextFormatter: (date, locale) =>
                DateFormat.E(locale).format(date)[0],
          ),
          calendarStyle: CalendarStyle(
            defaultTextStyle: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.w600),
            weekendTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            defaultDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(style: BorderStyle.none),
            ),
            todayTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onTertiary,
                  fontWeight: FontWeight.bold,
                ),
            todayDecoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
          ),
          headerVisible: false,
          daysOfWeekVisible: true,
          eventLoader: _getEventsForDay,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
          },
        ),
      ],
    );
  }
}
