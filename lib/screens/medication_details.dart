import 'package:capsule_app/models/medication.dart';
import 'package:flutter/material.dart';

class MedicationDetails extends StatefulWidget {
  const MedicationDetails({Key? key,this.medication})
      : super(key: key);
  final Medication? medication;

  @override
  _MedicationDetailsState createState() => _MedicationDetailsState();
}

class _MedicationDetailsState extends State<MedicationDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medication Details"),
      ),
      body: Center(
      child: Column(
        children: [
          Text(widget.medication!.name),
          Text(widget.medication!.dose),
          ElevatedButton(onPressed: (){}, child: Text("Go to details")),
        ],
      ),
    )
    );
  }
}
