class Notification {
  final int id;

  Notification(
      {required this.id,});

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: int.parse(json['id']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
    };
  }

}
