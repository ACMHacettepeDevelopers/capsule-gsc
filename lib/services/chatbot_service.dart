import 'dart:convert';
import 'package:capsule_app/models/firebase_message.dart';
import 'package:capsule_app/services/firebase_chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatBotService {
  var uuid = const Uuid();
  final FirebaseChatService firebaseChatService = FirebaseChatService();
  late ChatSession chat;
  Future<void> sendPrompt(String userInput) async {
    var content = Content.text(userInput);
    var response = await chat.sendMessage(content);
    final textMessage = types.TextMessage(
        author: const types.User(id: "model"),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: uuid.v8(),
        text: response.text ?? "I'm sorry, I don't understand that.");
    firebaseChatService.addBotMessageToChat(
        FirebaseAuth.instance.currentUser!.uid, jsonEncode(textMessage));
  }

  Future<void> initializeChatBot(List<Content> chatHistory) async {
    final generationConfig = GenerationConfig(
      topP: 0.9,
      temperature: 0.9,
      topK: 1,
      maxOutputTokens: 2048,
    );
    final safetySettings = [
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high)
    ];
    final initialText1 = TextPart(
        "You are a helpful assistant designed to provide short and concise responses to user queries related to medications. Aim to provide accurate and relevant information in a clear and brief manner. If a user requests information beyond your expertise or needs emergency assistance, advise them to consult a healthcare professional. Keep your responses friendly and informative. Don't answer irrelevant questions.");
    final initialText2 = TextPart("Hi there, how can I help you today?");
    final initialContent = [
      Content("user", [initialText1]),
      Content("model", [initialText2])
    ];
    final String key = dotenv.env['GEMINI_API_KEY']!;
    
  
    final model = GenerativeModel(
        safetySettings: safetySettings,
        generationConfig: generationConfig,
        model: "gemini-1.0-pro",
        apiKey: key);
       chat = model.startChat(history: initialContent + chatHistory);

    
    
    
    
    
    

  }
  Future<List<Content>> loadChatHistory() async {
    final chatHistory = await firebaseChatService.getMessagesFuture(
        FirebaseAuth.instance.currentUser!.uid);
    if (chatHistory.exists == false) {
      return [];
    }
    final chatHistoryData = chatHistory.data() as Map<String, dynamic>;
    final List<String> messages = List<String>.from(chatHistoryData['messages']);
    final List<Content> chatHistoryContent = [];
    for (var message in messages) {
      final Map<String, dynamic> messageMap = json.decode(message);
      final FirebaseMessage newMessage = FirebaseMessage.fromJson(messageMap);
      final author = newMessage.author["id"] == FirebaseAuth.instance.currentUser!.uid ? "user" : "model";
      chatHistoryContent.add(Content(author, [TextPart(newMessage.text)]));
    }
    return chatHistoryContent;
  }
}
 