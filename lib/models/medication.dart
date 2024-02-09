import 'dart:convert';

import 'package:flutter/material.dart';

enum MedicationStatus {
  taken,
  notTaken,
  scheduled,
}
enum MedicationType {
  pill,
  needle,
  // theraphy,
  // exercise,
}

class Medication {
  Medication({required this.medicationType,required this.dose,required this.status,  required this.dayAdded, required this.usageDays, required this.id, required this.name, required this.times});
  final String id;
  final String name;
  final String dose;
  final String status;
  final DateTime dayAdded;
  final String times;
  final int usageDays;

  MedicationType? medicationType;
   int get remainingDays {
    final DateTime endDay = dayAdded.add(Duration(days: usageDays));
    final int remaining = endDay.difference(DateTime.now()).inDays;
    return remaining >= 0 ? remaining : 0;
  }
  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'],
      name: json['name'],
      dose: json['dose'],
      status: json['status'],
      dayAdded: DateTime.parse(json['dayAdded']),
      usageDays: int.parse(json['usageDays']),
      times: json['times'],
      medicationType: MedicationType.values[json['medicationType']],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dose': dose,
      'times': times,
      'status': status,
      'usageDays': usageDays.toString(),
      'dayAdded': dayAdded.toIso8601String(),
      'medicationType': medicationType?.index,
    };
  }
}
