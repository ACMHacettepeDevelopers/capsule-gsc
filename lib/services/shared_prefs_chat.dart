// import 'dart:convert';

// import 'package:capsule_app/models/chat.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';

// class SharedPreferencesChatService {
//   late SharedPreferences _prefs;
//   var uuid = Uuid();
//   SharedPreferencesChatService() {
//     _initPrefs();
//   }

//   Future<void> _initPrefs() async {
//     _prefs = await SharedPreferences.getInstance();
//   }

//   List<Message> _getMessages(String chatId) {
//     final messagesString = await _prefs.getString(chatId);
//     return messagesString.split(',');
//   }

//   Future<void> startNewChat() async {
//     final chatId = uuid.v8();
//       await _prefs.setString(chatId, jsonEncode(Chat(id: chatId, messages: []).toJson()));

//   }

//   Future<void> addMessageToChat(String chatId, String message) async {
//     final List<String> messages = _getMessages(chatId);
//     messages.add(message);
//     await _prefs.setStringList(chatId, messages);
//   }

//   Future<void> addBotMessageToChat(String chatId, String message) async {
//     final List<String> messages = _getMessages(chatId);
//     messages.add(message);
//     await _prefs.setString(chatId, jsonEncode(Chat(id: chatId, messages: messages).toJson()));
//   }
// }
