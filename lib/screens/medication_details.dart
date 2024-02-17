import 'package:capsule_app/models/medication.dart';
import 'package:capsule_app/screens/calendar.dart';
import 'package:flutter/material.dart';
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
    return PageView(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: [Page1(medication: widget.medication)]);
  }
}

class Page1 extends StatelessWidget {
  final Medication? medication;

  const Page1({Key? key, this.medication}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[400],
      appBar: AppBar(
        title: Text(
          '${medication?.name ?? 'Medication Details'}', // İlaç adını yazın, eğer null ise "Medication Details" yazsın
        ),
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 100, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${medication?.name}', // İlaç adını yazın
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16), 

              Text("Medicine Type: ${medication?.medicationType}"),
              SizedBox(height: 40,)
                
                
                Container(
                  width: 200,
                  height: 200,
                  child: Table_Calender(
                    medication: medication!,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
