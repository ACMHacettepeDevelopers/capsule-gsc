import 'dart:convert';
import 'package:capsule_app/models/chat_response.dart';
import 'package:capsule_app/services/firebase_chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import "package:capsule_app/API_KEY.dart";
import "package:capsule_app/models/chat_request.dart";
import 'package:capsule_app/models/chatbot_message.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ChatBotService {
  var uuid = const Uuid();
  final FirebaseChatService firebaseChatService = FirebaseChatService();

  static final Uri chatUri =
      Uri.parse('https://api.openai.com/v1/chat/completions');
  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${ApiKey.openAIApiKey}',
  };
  Future<void> sendPrompt(String userInput) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final conversation = (jsonDecode(prefs.getString("conversation")!)
            as List<dynamic>)
        .map((item) => ChatBotMessage.fromJson(item as Map<String, dynamic>))
        .toList();
    conversation.add(ChatBotMessage(role: "user", content: userInput));
    for(var text in conversation){
      print(text.content);
    }
    ChatRequest request =
        ChatRequest(model: "gpt-3.5-turbo-1106", messages: conversation, temperature: 0.2 );
    http.Response response = await http.post(
      chatUri,
      headers: headers,
      body: request.toJson(),
    );

    ChatResponse chatResponse = ChatResponse.fromResponse(response);
    final textMessage = types.TextMessage(
      author: const types.User(id: "ChatBot"),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: uuid.v8(),
      text: chatResponse.choices?[0].message?.content ??
          "I can only answer questions about your medication.",
    );
    firebaseChatService.addBotMessageToChat(
        FirebaseAuth.instance.currentUser!.uid, jsonEncode(textMessage));
    print(chatResponse.choices?[0].message?.content);
  }

  Future<void> initializeConversation(List<ChatBotMessage> conversation) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("conversation", jsonEncode(conversation));
  }

  Future<void> initializeChatBot() async {
    final drugInfo = await getDrugInfo();
    final conversation = [
      ChatBotMessage(
          role: "system",
          content:
              "You are a pharmacist. You are helping a patient understand their medication. Do not mention how the information is obtained. Do not use any other sources of information."),
      ChatBotMessage(role: "system", content: "Drug Info $drugInfo")
    ];
    ChatRequest request =
        ChatRequest(model: "gpt-3.5-turbo-1106", messages: conversation);
    await initializeConversation(conversation);
    await http.post(
      chatUri,
      headers: headers,
      body: request.toJson(),
    );
  }

  static Future<String> getDrugInfo(
      {String drugId = "f6f3c339-2c9d-4d07-14a1-6d6c7daf26c6"}) async {
    try {
      var url = Uri.parse(
          "https://api.fda.gov/drug/label.json?search=set_id:$drugId&limit=1");  //buraya kullanıcının kayıt ettiği ilaçların idleri gönderilebilir.
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var filteredData = {
          for (var entry in data["results"][0].entries)
            if ([
              "brand_name",
                "generic_name",
                "active_ingredient",
                "boxed_warning",
                "indications_and_usage",
                "dosage_and_administration",
                "contraindications",
                "adverse_reactions",
                "drug_interactions",
                "warnings_and_cautions",
                "adverse_reactions",
                "description",
                "pediatric_use",
                "geriatric_use",
                "pregnancy",
                "lactation",
                "information_for_patients",
            ].contains(entry.key))
              entry.key: entry.value,
        };
        var filteredDataJson = json.encode(
          filteredData,
          toEncodable: (value) => value.toString(),
        );
        return filteredDataJson;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
