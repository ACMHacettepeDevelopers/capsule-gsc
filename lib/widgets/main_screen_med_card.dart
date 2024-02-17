import 'dart:convert';

import 'package:capsule_app/models/medication.dart';
import 'package:capsule_app/services/medications_local_service.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MedicationCard extends StatefulWidget {
  Medication medication;

  MedicationCard({Key? key, required this.medication}) : super(key: key);

  @override
  _MedicationCardState createState() => _MedicationCardState();
}

class _MedicationCardState extends State<MedicationCard> {
  late Map<String, dynamic> selectedTimes;

  @override
  void initState() {
    super.initState();
    selectedTimes = jsonDecode(widget.medication.times);
  }

  @override
  Widget build(BuildContext context) {
    bool isTaken = widget.medication.status == MedicationStatus.taken.toString()
        ? true
        : false;
    return Card(
      color: isTaken ? Colors.green[100] : Colors.white,
      elevation: 3,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.medication.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Image.asset(
                  widget.medication.medicationType == MedicationType.pill
                      ? 'lib/assets/pill.png'
                      : widget.medication.medicationType ==
                              MedicationType.needle
                          ? 'lib/assets/needle.png'
                          : 'lib/assets/syrup.png',
                  height: 35,
                  width: 35,
                )
              ],
            ),
            const SizedBox(height: 8),
            Text('Days Left: ${widget.medication.remainingDays}'),
            const SizedBox(height: 8),
            const Text('Scheduled Times',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Column(
              children: _buildTimeCheckboxes(context),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTimeCheckboxes(BuildContext context) {
    bool allSelected = true;

    final checkboxes = selectedTimes.entries.map((entry) {
      final String time = entry.key;
      final bool isChecked = entry.value;

      if (!isChecked) {
        allSelected = false;
      }

      return Row(
        children: [
          Text('Time: $time'),
          const SizedBox(width: 8),
          Checkbox(
            value: isChecked,
            onChanged: (value) {
              setState(() {
                selectedTimes[time] = value ?? false;
                _updateMedicationStatus();
              });
            },
          ),
        ],
      );
    }).toList();

    if (allSelected) {
      checkboxes.clear();
      checkboxes.add(const Row(
        children: [
          Text('You have taken all your medication for today!'),
          SizedBox(width: 8),
          Icon(Icons.check),
        ],
      ));
    }

    return checkboxes;
  }

  void _updateMedicationStatus() {
  bool allSelected = true;

  for (final entry in selectedTimes.entries) {
    if (!entry.value) {
      allSelected = false;
      break;
    }
  }

  DateTime today = DateTime.now();
  DateTime todayWithoutTime = DateTime(today.year, today.month, today.day);

  final updatedMedication = widget.medication.copyWith(
    times: jsonEncode(selectedTimes),
    status: allSelected
        ? MedicationStatus.taken.toString()
        : MedicationStatus.notTaken.toString(),
  );

  if (updatedMedication.status == MedicationStatus.taken.toString()) {
    updatedMedication.usageDaysMap[todayWithoutTime] = true;
  }
  print(updatedMedication.usageDaysMap);

  MedicationsService().updateMedication(updatedMedication);

  setState(() {
    widget.medication = updatedMedication;
  });
}

}
