class FirebaseMessage{
  final Map<String,dynamic> author;
  final String text;
  final DateTime createdAt;
  final String id;
  FirebaseMessage({required this.author,required this.text,required this.createdAt,required this.id});



  FirebaseMessage.fromJson(Map<String,dynamic> json)
  : author = json['author'],
    text = json['text'],
    createdAt = DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    id = json['id'];
  }