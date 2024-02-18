import 'dart:convert';
import 'package:capsule_app/services/chatbot_service.dart';
import 'package:capsule_app/services/firebase_chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseChatService firebaseChatService = FirebaseChatService();
  final ChatBotService chatBotService = ChatBotService();
  var uuid = const Uuid();
  @override
  void initState() {
    super.initState();
    initalizeChatBot();
  }
  Future<void> initalizeChatBot() async {
    final oldChat = await chatBotService.loadChatHistory();
    await chatBotService.initializeChatBot(oldChat);

    
    
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gemini Chat"), actions: [
        ElevatedButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Delete Chat'),
                  content:
                      const Text('Are you sure you want to delete this chat?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.black)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Delete',
                          style: TextStyle(color: Colors.red)),
                      onPressed: () async {
                        await firebaseChatService.deleteChat(currentUserUid);
                        if (mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.delete),
        )
      ]),
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
                  const Text("You can start a new chat with the chat bot."),
                  ElevatedButton(
                    onPressed: () async {
                      await firebaseChatService.startNewChat(currentUserUid);
                      await initalizeChatBot();
                    },
                    child: const Text("Create Chat"),
                  ),
                ],
              ),
            );
          }

          List<types.Message> _messages = [];

          if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
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
            inputOptions: const InputOptions(
                autocorrect: false, inputClearMode: InputClearMode.always),
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
      id: uuid.v8(),
      text: message.text,
    );
    await firebaseChatService.addMessageToChat(
        currentUserUid, json.encode(textMessage));
    await chatBotService.sendPrompt(message.text);
  }
}
