enum MedicationStatus{taken, notTaken, scheduled, }
class Medication{
  Medication({required this.status});
  MedicationStatus? status;

}