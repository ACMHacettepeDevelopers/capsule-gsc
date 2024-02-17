import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:capsule_app/models/medication.dart';
import 'package:capsule_app/models/notification.dart';
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
              id: medication.notificationId,  // UNIQUE ID GEREKIR MI?
              channelKey: 'basic_channel',
              title: 'Hey buddy! Time to take your medication!',
              body: "${medication.name} needs to be taken now."),
          schedule: NotificationAndroidCrontab.daily(referenceDateTime: time,),
          
        );
      }
      if (Platform.isIOS) {
        for (int i = 0; i < medication.usageDays; i++) {
          DateTime time = DateTime(now.year, now.month, now.day + i,
              format.parse(timeString).hour, format.parse(timeString).minute);
           AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: medication.notificationId,
              channelKey: 'basic_channel',
              title: 'Hey buddy! Time to take your medication!',
              body: "${medication.name} needs to be taken now.",
            ),
            schedule: NotificationCalendar.fromDate(date: time),
          );
        }
      }
      
      final notification = Notification(id: medication.notificationId,);
        final List<String> notifications = prefs.getStringList("notifications") ?? [];
        notifications.add(jsonEncode(notification.toJson()));
        prefs.setStringList("notifications", notifications);
    });
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> notifications = prefs.getStringList("notifications") ?? [];
    List<Notification>  notificationList = notifications.map((e) => Notification.fromJson(jsonDecode(e))).toList();
    final List<String> medications = prefs.getStringList("medications") ?? [];
      AwesomeNotifications().cancelSchedule(notificationList.firstWhere((element) => element.id == medication.notificationId).id);
      print("DELETED NOTIFICATION ${medication.times}");
      
      notificationList.removeWhere((element) => element.id == medication.notificationId);
      prefs.setStringList("notifications", notificationList.map((e) => jsonEncode(e)).toList());
      
    medications.remove(jsonEncode(medication));
    await prefs.setStringList("medications", medications);
  }

  // Future<void> updateMedicationsStatusUpdate() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final lastLogin =
  //       prefs.getString("lastLogin") ?? DateTime.now().toIso8601String();
  //   final now = DateTime.now();
  //   final difference = now.difference(DateTime.parse(lastLogin)).inDays;
  //   if (difference > 0) {
  //     final List<Medication> medications = await getMedicationsFromLocal();
  //     for (var medication in medications) {
  //       final DateTime endDay =
  //           medication.dayAdded.add(Duration(days: medication.usageDays));
  //       final int remainingDays = endDay.difference(now).inDays;
  //       if (remainingDays == 0) {
  //         deleteMedication(medication);
  //       }
  //     }
  //   }
  //   await prefs.setString("lastLogin", now.toIso8601String());
  // }

Future<void> updateMedicationsStatusUpdate() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String> medications = prefs.getStringList("medications") ?? [];

  for (String medicationString in medications) {
    Medication medication = Medication.fromJson(jsonDecode(medicationString));

    // Check if today's date is in the usageDaysMap
    DateTime today = DateTime.now();
    DateTime todayWithoutTime = DateTime(today.year, today.month, today.day);

    if (medication.usageDaysMap.containsKey(todayWithoutTime)) {
      medication.status = medication.usageDaysMap[todayWithoutTime]!
          ? MedicationStatus.taken.toString()
          : MedicationStatus.notTaken.toString();
    }

    await updateMedication(medication);
  }
}

}
