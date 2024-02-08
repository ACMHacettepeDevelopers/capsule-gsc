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
  Medication({required this.medicationType,required this.status,required this.dose, required this.dayAdded, required this.usageDays, required this.id, required this.name});
  final String id;
  final String name;
  final String dose;
  final DateTime dayAdded;
  final int usageDays;
  MedicationStatus? status;
  MedicationType? medicationType;
  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'],
      name: json['name'],
      dose: json['dose'],
      dayAdded: DateTime.parse(json['dayAdded']),
      usageDays: int.parse(json['usageDays']),
      status: MedicationStatus.values[json['status']],
      medicationType: MedicationType.values[json['medicationType']],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dose': dose,
      'usageDays': usageDays.toString(),
      'dayAdded': dayAdded.toIso8601String(),
      'status': status?.index,
      'medicationType': medicationType?.index,
    };
  }
}
