import 'dart:async';
import 'dart:convert';
import 'package:capsule_app/models/medication.dart';
import "package:shared_preferences/shared_preferences.dart";

class MedicationsService {


  Future<List<Medication>> getMedicationsFromLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> medications = prefs.getStringList("medications") ?? [];
    return medications.map((e) => Medication.fromJson(jsonDecode(e))).toList();
  }

  Future<void> addMedication(Medication medication) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> medications = prefs.getStringList("medications") ?? [];
    medications.add(jsonEncode(medication.toJson()));
    await prefs.setStringList("medications", medications);
  }

  Future<void> updateMedication(Medication medication) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> medications = prefs.getStringList("medications") ?? [];
    final index = medications
        .indexWhere((element) => jsonDecode(element)["id"] == medication.id);
    medications[index] = jsonEncode(medication);
    await prefs.setStringList("medications", medications);
  }

  Future<void> deleteMedication(Medication medication) async {
    // Delete the medication from the local dat abase
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> medications = prefs.getStringList("medications") ?? [];
    print(medications);
    medications.remove(jsonEncode(medication));
    await prefs.setStringList("medications", medications);
  }
//   Future<List<Medication>> getMedicationsWithRemainingDays() async {
//   final List<Medication> medications = await getMedicationsFromLocal();
//   final DateTime now = DateTime.now();
//   for (var medication in medications) {
//     final DateTime endDay = medication.dayAdded.add(Duration(days: medication.usageDays));
//     final int remainingDays = endDay.difference(now).inDays;
//   }
//   return medications;
// }
}
