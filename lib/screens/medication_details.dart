import 'package:flutter/material.dart';
import 'package:capsule_app/models/medication.dart';
import 'package:capsule_app/screens/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class MedicationDetails extends StatefulWidget {
  const MedicationDetails({Key? key, this.medication}) : super(key: key);
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
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Title_Text(widget.medication!.name),
              SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.center,
                height: 40,
                width: 240,
                child: Center(
                  child: Text(
                    "From ${widget.medication?.dayAdded}-- To ${widget.medication?.endDay}",
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 15,
              ),
              subTitle("Medication Dosage"),
              SizedBox(
                height: 10,
              ),
              AboutMedicine(widget.medication!.name, widget.medication!.dose),
              SizedBox(
                height: 15,
              ),
              subTitle("Medication Time"),
              SizedBox(
                height: 10,
              ),
              AboutMedicine(
                  widget.medication!.name, widget.medication!.times + " times"),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 400,
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
    padding: EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black,
          offset: Offset(4, 4),
          blurRadius: 10,
        ),
      ],
      color: Colors.amber[200],
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: Center(
      child: Text(
        "More Information About ${title}",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    ),
  );
}

Container AboutMedicine(String name, String details) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.green[200],
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    height: 40,
    width: "${name} has ${details} in a day. You do not forget it"
            .length
            .toDouble() *
        10,
    child: Center(
      child: Text(
        "${name} has ${details} in a day. You do not forget it",
        style: TextStyle(
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
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  );
}
