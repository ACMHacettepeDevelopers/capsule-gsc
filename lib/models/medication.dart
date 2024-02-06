enum MedicationStatus {
  taken,
  notTaken,
  scheduled,
}
enum MedicationType {
  pill,
  needle,
  theraphy,
  exercise,
}

class Medication {
  Medication({required this.medicationType,required this.status,required this.dose, required this.time, required this.id, required this.name});
  final String id;
  final String name;
  final String dose;
  final String time;
  MedicationStatus? status;
  MedicationType? medicationType;
  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'],
      name: json['name'],
      dose: json['dose'],
      time: json['time'],
      status: MedicationStatus.values[json['status']],
      medicationType: MedicationType.values[json['medicationType']],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dose': dose,
      'time': time,
      'status': status?.index,
      'medicationType': medicationType?.index,
    };
  }
}
