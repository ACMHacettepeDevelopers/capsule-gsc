enum MedicationStatus {
  taken,
  notTaken,
  scheduled,
}

enum MedicationType {
  pill,
  needle,
  syrup,
  // theraphy,
  // exercise,
}

class Medication {
   Medication({
    required this.notificationId,
    required this.medicationType,
    required this.dose,
    required this.status,
    required this.dayAdded,
    required this.usageDays,
    required this.id,
    required this.name,
    required this.times,
    this.usageDaysMap = const {},
  }) {
    _initializeUsageDays();
  }
  final int notificationId;
  final String id;
  final String name;
  String dose;
  String status;
  Map<DateTime,bool> usageDaysMap = {};
  final DateTime dayAdded;
  final String times;
  final int usageDays;

  MedicationType? medicationType;
  int get remainingDays {
    final DateTime endDay = dayAdded.add(Duration(days: usageDays));
    final int remaining = endDay.difference(DateTime.now()).inDays;
    return remaining >= 0 ? remaining : 0;
  }
  

  
  DateTime get endDay => dayAdded.add(Duration(days: usageDays));
  factory Medication.fromJson(Map<String, dynamic> json) {
  return Medication(
    notificationId: int.parse(json['notificationId']),
    id: json['id'],
    name: json['name'],
    dose: json['dose'],
    status: json['status'],
    dayAdded: DateTime.parse(json['dayAdded']),
    usageDays: int.parse(json['usageDays']),
    times: json['times'],
    medicationType: MedicationType.values[json['medicationType']],
    usageDaysMap: (json['usageDaysMap'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(DateTime.parse(key), value as bool),
    ),
  );
}

Map<String, dynamic> toJson() {
  return {
    'notificationId': notificationId.toString(),
    'id': id,
    'name': name,
    'dose': dose,
    'times': times,
    'status': status,
    'usageDays': usageDays.toString(),
    'dayAdded': dayAdded.toIso8601String(),
    'medicationType': medicationType?.index,
    'usageDaysMap': usageDaysMap.map((key, value) => MapEntry(key.toIso8601String(), value)),
  };
}
  // copy with
  Medication copyWith({
    String? name,
    String? dose,
    String? status,
    DateTime? dayAdded,
    int? usageDays,
    String? times,
    MedicationType? medicationType,
    Map<DateTime,bool>? usageDaysMap,
  }) {
    return Medication(
      notificationId: notificationId,
      id: id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      status: status ?? this.status,
      dayAdded: dayAdded ?? this.dayAdded,
      usageDays: usageDays ?? this.usageDays,
      times: times ?? this.times,
      medicationType: medicationType ?? this.medicationType,
      usageDaysMap: usageDaysMap ?? this.usageDaysMap,
    );
  }
  void _initializeUsageDays() {
    usageDaysMap = {};
    for (int i = 0; i < usageDays; i++) {
      DateTime usageDay = dayAdded.add(Duration(days: i));
      DateTime formattedDay = DateTime(usageDay.year, usageDay.month, usageDay.day);
      usageDaysMap[formattedDay] = false;
    }
  }


}
