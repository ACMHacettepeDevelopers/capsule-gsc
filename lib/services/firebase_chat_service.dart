import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Stream<DocumentSnapshot> getChatMessages(String userId) {
    return _firestore
        .collection('chats')
        .doc(userId)
        .snapshots();
  }
  Future<DocumentSnapshot> getMessagesFuture(String userId) {
    return _firestore
        .collection('chats')
        .doc(userId)
        .get();

  }

  Future<void> startNewChat(String userId) async {
    final chat = await _firestore
        .collection('chats')
        .doc(
          userId,
        )
        .get();
    if (!chat.exists) {
      await _firestore.collection('chats').doc(userId).set({
        'messages': [],
      });
    }
    return;
  }
   Future<void> deleteChat(String userId) async {
    await _firestore.collection('chats').doc(userId).delete();}

  //add message to chat
  Future<void> addMessageToChat(String userId, String message) async {
    final chat = await _firestore.collection('chats').doc(userId).get();

    final chatData = chat.data() as Map<String, dynamic>;
    final List<String> messages = List<String>.from(chatData['messages']);
    messages.add(message);
    await _firestore.collection('chats').doc(userId).set({
      'messages': messages,
    });
  }
   Future<void> addBotMessageToChat(String userId, String message) async {
    final chat = await _firestore.collection('chats').doc(userId).get();

    final chatData = chat.data() as Map<String, dynamic>;
    final List<String> messages = List<String>.from(chatData['messages']);
    messages.add(message);
    await _firestore.collection('chats').doc(userId).set({
      'messages': messages,
    });
  }
}
