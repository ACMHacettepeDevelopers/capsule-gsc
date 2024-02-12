import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:capsule_app/models/medication.dart';
import "package:shared_preferences/shared_preferences.dart";
import "package:awesome_notifications/awesome_notifications.dart";
import 'package:intl/intl.dart';

class MedicationsService {
  Future<List<Medication>> getMedicationsFromLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> medications = prefs.getStringList("medications") ?? [];
    return medications.map((e) => Medication.fromJson(jsonDecode(e))).toList();
  }

  Future<void> addMedication(Medication medication) async {
    DateFormat format;
    final Map<String, dynamic> times =
        jsonDecode(medication.times) as Map<String, dynamic>;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> medications = prefs.getStringList("medications") ?? [];
    medications.add(jsonEncode(medication.toJson()));

    await prefs.setStringList("medications", medications);
    times.forEach((timeString, value) {
      if (timeString.contains(RegExp(r'AM|PM', caseSensitive: false))) {
        format = DateFormat("h:mm a");
      } else {
        format = DateFormat("HH:mm");
      }
      DateTime now = DateTime.now();
      if (Platform.isAndroid) {
        DateTime time = format.parse(timeString);
        AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1,
              channelKey: 'basic_channel',
              title: 'Hey buddy! Time to take your medication!',
              body: "${medication.name} needs to be taken now."),
          schedule: NotificationAndroidCrontab.daily(referenceDateTime: time),
        );
        print("Notification is created for $time");
      }
      if (Platform.isIOS) {
        DateTime time = DateTime(now.year, now.month, now.day,
            format.parse(timeString).hour, format.parse(timeString).minute);
        AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1,
              channelKey: 'basic_channel',
              title: 'Hey buddy! Time to take your medication!',
              body: "${medication.name} needs to be taken now."),
              schedule: NotificationCalendar.fromDate(date: time),
        );
      }
    });
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
  Future<void>updateMedicationsStatusUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLogin = prefs.getString("lastLogin") ?? DateTime.now().toIso8601String();
    final now = DateTime.now();
    final difference = now.difference(DateTime.parse(lastLogin)).inDays;
    print(difference);
    if (difference > 0) {
      
      final List<Medication> medications = await getMedicationsFromLocal();
      for (var medication in medications) {
        final DateTime endDay = medication.dayAdded.add(Duration(days: medication.usageDays));
        final int remainingDays = endDay.difference(now).inDays;
        if (remainingDays <= 0) {
          medication.status = MedicationStatus.notTaken.toString();
          updateMedication(medication);
        }
      }
    }
    await prefs.setString("lastLogin", now.toIso8601String());
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
