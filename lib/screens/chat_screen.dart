import 'dart:convert';
import 'dart:math';
import 'package:capsule_app/services/chatbot_service.dart';
import 'package:capsule_app/services/firebase_chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseChatService firebaseChatService = FirebaseChatService();
  final ChatBotService chatBotService = ChatBotService();
  List<types.Message> _messages = [];
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: firebaseChatService.getChatMessages(currentUserUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No data"),
                  ElevatedButton(
                    onPressed: () async {
                      await firebaseChatService.startNewChat(currentUserUid);
                      await ChatBotService.initializeChatBot();
                    },
                    child: const Text("Create Chat"),
                  ),
                ],
              ),
            );
          }

          List<types.Message> _messages = [];

          if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            if (data.containsKey('messages')) {
              List<String> messages = List<String>.from(data['messages']);

              for (var message in messages) {
                final Map<String, dynamic> messageMap = json.decode(message);
                final types.Message newMessage =
                    types.TextMessage.fromJson(messageMap);
                _messages.insert(0, newMessage);
              }
            }
          }

          return Chat(
            user: types.User(
              id: currentUserUid,
            ),
            messages: _messages,
            onSendPressed: _handleSendPressed,
            inputOptions: InputOptions(
                autocorrect: false,
                textEditingController: _textEditingController),
          );
        },
      ),
    );
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: types.User(
          id: currentUserUid), // user image eklenince buraya da eklenecek.
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );
    await firebaseChatService.addMessageToChat(
        currentUserUid, json.encode(textMessage));
    await chatBotService.sendPrompt(message.text);

    _textEditingController.clear();
  }

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }
}
