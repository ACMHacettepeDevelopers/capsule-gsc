import 'dart:convert';

import 'package:capsule_app/models/medication.dart';
import 'package:capsule_app/services/medications_local_service.dart';
import 'package:flutter/material.dart';

class MedicationCard extends StatefulWidget {
  final Medication medication;

  const MedicationCard({Key? key, required this.medication}) : super(key: key);

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
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medication: ${widget.medication.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Days Left: ${widget.medication.remainingDays}'),
            const SizedBox(height: 8),
            const Text('Scheduled Times', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
    bool allSelected = widget.medication.status == MedicationStatus.taken.toString();

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
              });
              _updateMedicationStatus();
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

    final updatedMedication = Medication(
      id: widget.medication.id,
      name: widget.medication.name,
      dose: widget.medication.dose,
      status: allSelected ? MedicationStatus.taken.toString() : MedicationStatus.notTaken.toString(),
      dayAdded: widget.medication.dayAdded,
      usageDays: widget.medication.usageDays,
      times: jsonEncode(selectedTimes),
      medicationType: widget.medication.medicationType,
    );

    MedicationsService().updateMedication(updatedMedication);
  }
}
