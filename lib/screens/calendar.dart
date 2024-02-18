import 'package:flutter/material.dart';
import 'package:capsule_app/models/medication.dart';
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
      appBar: AppBar(title: const Text("hello")),
      body: content(), //
    );
  }

  Widget content() {
    return Column(
      children: [
        TableCalendar(
          startingDayOfWeek: StartingDayOfWeek.monday,
        
          weekendDays: const [DateTime.saturday, DateTime.sunday],
          rowHeight: 53,
          availableGestures: AvailableGestures.all,
          headerStyle:
              const HeaderStyle(formatButtonVisible: false, titleCentered: true),
          focusedDay: today,
          firstDay: widget.medication.dayAdded,
          lastDay: widget.medication.endDay,
          selectedDayPredicate: (day) =>
              isSameDay(day, widget.medication.dayAdded),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              DateTime dayWithoutTime = DateTime(day.year, day.month, day.day);
              DateTime todayWithoutTime = DateTime(today.year, today.month, today.day);
              today = dayWithoutTime.subtract(const Duration(days: 1));
              bool isDayTaken = widget.medication.usageDaysMap[dayWithoutTime] == true;
              if (isDayTaken) { 
                return takenBoxPill();
              } else if(!isDayTaken && dayWithoutTime.isBefore(todayWithoutTime)){
                return notTakenBoxPill();
              } 
              return unknownBoxPill(date: day);
            },
          ),
          calendarStyle: const CalendarStyle(
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

Widget takenBoxPill() {
  return CalendarBoxes(
    child: const Icon(
      Icons.check,
      size: 30,
      color: Colors.white,
    ),
  );
}

Widget notTakenBoxPill() {
  return CalendarBoxes(
    child: const Icon(Icons.clear, size: 30, color: Colors.red),
  );
}

Widget unknownBoxPill({required DateTime date}) {
  return CalendarBoxes(
    child: const Icon(
      Icons.schedule,
      size: 30,
      color: Colors.white,
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
