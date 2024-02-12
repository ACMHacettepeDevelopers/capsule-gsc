import 'dart:convert';
import 'package:capsule_app/models/medication.dart';
import 'package:capsule_app/services/medications_local_service.dart';
import 'package:capsule_app/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddMedication extends StatefulWidget {
  const AddMedication({Key? key}) : super(key: key);

  @override
  _AddMedicationState createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication> {
  List<TimeOfDay> _times = [];
  final MedicationsService medicationsService = MedicationsService();
  final formKey = GlobalKey<FormState>();
  final validator = Validator();
  bool isTimePickerOn = false;
  var _medicationName = "";
  var _dose = "";
  var _type = MedicationType.pill;
  var _time = "";
  Uuid uuid = const Uuid();

  Map<String, bool> _selectedTimes = {};

  List<Widget> _buildTimePickers(BuildContext context, int _dose) {
    List<Widget> timePickers = [];

    for (int i = 0; i < _dose; i++) {
      String buttonText = i < _times.length
          ? _times[i].format(context)
          : 'Select time ${i + 1}';

      timePickers.add(
        ElevatedButton(
          onPressed: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: _times.length > i ? _times[i] : TimeOfDay.now(),
            );
            if (pickedTime != null) {
              String formattedTime = pickedTime.format(context);
              if (_selectedTimes.containsKey(formattedTime)) {
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Duplicate Time'),
                        content: const Text('Selected time is already chosen.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                setState(() {
                  _times.add(pickedTime);
                  _selectedTimes[formattedTime] =
                      false; 
                });
              }
            }
          },
          child: Text(buttonText),
        ),
      );
    }
    return timePickers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Medication"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: "Medication Name"),
                  validator: validator.medicationNameValidator,
                  onSaved: (newValue) => _medicationName = newValue!,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: "Dose (Daily amount)"),
                  validator: validator.medicationDoseValidator,
                  keyboardType: TextInputType.number,
                  onSaved: (newValue) {
                    setState(() {
                      _dose = newValue!;
                      isTimePickerOn = true;
                    });
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: "Usage Time (Days)"),
                  validator: validator.medicationUsageValidator,
                  onSaved: (newValue) => _time = newValue!,
                ),
                DropdownButton<MedicationType>(
                  value: _type,
                  onChanged: (newType) {
                    setState(() {
                      _type = newType!;
                    });
                  },
                  items: MedicationType.values
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.toString().split('.').last),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 200),
                if (isTimePickerOn)
                  ..._buildTimePickers(context, int.parse(_dose)),
                !isTimePickerOn
                    ? ElevatedButton(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          formKey.currentState!.save();
                          setState(() {
                            isTimePickerOn = true;
                          });
                        },
                        child: const Text("Save and pick time"),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          await medicationsService.addMedication(
                            Medication(
                              id: DateTime.now().toString(),
                              name: _medicationName,
                              dose: _dose,
                              status: "notTaken",
                              usageDays: int.parse(_time),
                              medicationType: _type,
                              dayAdded: DateTime.now(),
                              times: jsonEncode(_selectedTimes),
                            ),
                          );

                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text("Add Medication"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
