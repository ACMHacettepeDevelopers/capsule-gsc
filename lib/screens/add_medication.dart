import 'package:capsule_app/models/medication.dart';
import 'package:capsule_app/services/medications_local_service.dart';
import 'package:capsule_app/utils/validators.dart';
import 'package:flutter/material.dart';

class AddMedication extends StatefulWidget {
  const AddMedication({Key? key}) : super(key: key);

  @override
  _AddMedicationState createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication> {
  final MedicationsService medicationsService = MedicationsService();
  final formKey = GlobalKey<FormState>();
  final validator = Validator();
  var _medicationName = "";
  var _dose = "";
  var _type = MedicationType.pill;
  var _time = "";
  @override
  Widget build(BuildContext context) {
    // text form to add medication
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Medication"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                
                decoration: const InputDecoration(labelText: "Medication Name"),
                validator: validator.medicationNameValidator,
                onSaved: (newValue) => _medicationName = newValue!,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Dose (Daily amount)"),
                validator: validator.medicationDoseValidator,
                onSaved: (newValue) => _dose = newValue!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Usage Time (Days)"),
                validator: validator.medicationDoseValidator,
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
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  formKey.currentState!.save();

                  await medicationsService.addMedication(Medication(
                    id: DateTime.now().toString(),
                    name: _medicationName,
                    dose: _dose,
                    usageDays: int.parse(_time),
                    status: MedicationStatus.notTaken,
                    medicationType: _type,
                    dayAdded: DateTime.now(),
                  ));

                  if(context.mounted){
                    
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Add Medication"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
