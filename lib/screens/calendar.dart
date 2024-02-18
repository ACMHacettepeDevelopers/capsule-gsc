import 'package:flutter/material.dart';
import 'package:capsule_app/models/medication.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:table_calendar/table_calendar.dart';

class Table_Calender extends StatefulWidget {
  const Table_Calender({super.key, required this.medication});
  final Medication medication;

  @override
  State<StatefulWidget> createState() => _Table1Calender();
}

class _Table1Calender extends State<Table_Calender> {
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content(), //
    );
  }

  Widget content() {
    return Column(
      children: [
        TableCalendar(
          startingDayOfWeek: StartingDayOfWeek.monday,
          daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              weekendStyle:
                  TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),

          weekendDays: [DateTime.saturday, DateTime.sunday],
          rowHeight: 35,

          availableGestures: AvailableGestures.all,
          headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          focusedDay: widget.medication.dayAdded,
          firstDay: widget.medication.dayAdded,
          lastDay: widget.medication.endDay,
          selectedDayPredicate: (day) =>
              isSameDay(day, widget.medication.dayAdded),
          //selectedDayPredicate
          calendarBuilders: CalendarBuilders(
            selectedBuilder: (context, day, focusedDay) {
              if (widget.medication.status ==
                  MedicationStatus.taken.toString()) {
                return TakenBoxPill();
              } else if (widget.medication.status ==
                  MedicationStatus.notTaken.toString()) {
                return NotTakenBoxPill();
              } else {
                return UnknownBoxPill(date: day);
              }
            },
          ),
          calendarStyle: const CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            defaultTextStyle:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            weekendTextStyle: TextStyle(
                color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

Widget TakenBoxPill() {
  return CalendarBoxes(
    child: const Icon(
      Icons.check,
      size: 30,
      color: Colors.white,
    ),
  );
}

Widget NotTakenBoxPill() {
  return CalendarBoxes(
    child: const Icon(Icons.clear, size: 30, color: Colors.red),
  );
}

Widget UnknownBoxPill({required DateTime date}) {
  return CalendarBoxes(
    child: Text(
      date.day.toString(),
      style: const TextStyle(color: Colors.black87),
    ),
  );
}

Widget CalendarBoxes({required Widget child}) {
  return Container(
    margin: const EdgeInsets.all(4.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: child,
  );
}
