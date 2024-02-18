import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:capsule_app/models/medication.dart';
import 'package:capsule_app/screens/calendar.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MedicationDetails extends StatefulWidget {
  const MedicationDetails({Key? key, required this.medication}) : super(key: key);
  final Medication? medication;

  @override
  _MedicationDetailsState createState() => _MedicationDetailsState();
}

class _MedicationDetailsState extends State<MedicationDetails> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Title_Text(widget.medication!.name),
              const SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.center,
                height: 40,
                width: 240,
                child: Center(
                  child: Text(
                    "From ${DateFormat('yyy-MM-dd').format(widget.medication!.dayAdded)}-- To ${DateFormat('yyy-MM-dd').format(widget.medication!.endDay)}",
                    style: const TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 15,
              ),
              subTitle("Medication Dosage"),
              const SizedBox(
                height: 10,
              ),
              aboutMedicine(widget.medication!),
              const SizedBox(
                height: 15,
              ),
              subTitle("Medication Time"),
              const SizedBox(
                height: 10,
              ),
              aboutMedicine(
                   widget.medication
                   !),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 500,
                child: Table_Calender(medication: widget.medication!),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Container Title_Text(String title) {
  return Container(
    height: 40,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      boxShadow: const [
         BoxShadow(
          color: Colors.black,
          offset: Offset(4, 4),
          blurRadius: 10,
        ),
      ],
      color: Colors.amber[200],
      borderRadius: const BorderRadius.all(Radius.circular(20)),
    ),
    child: Center(
      child: Text(
        "More Information About ${title}",
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    ),
  );
}

Container aboutMedicine(Medication medication) {
  final name = medication.name;
  final times = jsonDecode(medication.times) as Map<String, dynamic>;
  final timesArray = times.keys.toList();
  return Container(
    decoration: BoxDecoration(
      color: Colors.green[200],
      borderRadius: const BorderRadius.all(Radius.circular(20)),
    ),
    height: 40,
    width: "$name has ${medication.dose} doses in a day. You do not forget it"
            .length
            .toDouble() *
        10,
    child: Center(
      child: Text(
        "$name has to be taken at ${timesArray.join(", ")}",
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    ),
  );
}

Widget subTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  );
}
