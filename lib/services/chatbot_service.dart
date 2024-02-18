import 'dart:convert';
import 'package:capsule_app/services/firebase_chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:capsule_app/API_KEY.dart";
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
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

  Future<void> initializeChatBot() async {
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
    final model = GenerativeModel(
        safetySettings: safetySettings,
        generationConfig: generationConfig,
        model: "gemini-1.0-pro",
        apiKey: ApiKey.googleApiKey);
    final initialText1 = TextPart(
        "You are a pharmacist. You are helping a patient understand their medication. Do not mention how the information is obtained. Do not use any other sources of information.");
    final initialText2 = TextPart("Hi there, how can I help you today?");
    chat = model.startChat(history: [
      Content("user", [initialText1]),
      Content("model", [initialText2])
    ]);
  }
}
 // Future<void> initializeChatBot() async {
  //   final drugInfo = await getDrugInfo();
  //   final conversation = [
  //     ChatBotMessage(
  //         role: "system",
  //         content:
  //             "You are a pharmacist. You are helping a patient understand their medication. Do not mention how the information is obtained. Do not use any other sources of information."),
  //     ChatBotMessage(role: "system", content: "Drug Info $drugInfo")
  //   ];
  //   ChatRequest request =
  //       ChatRequest(model: "gpt-3.5-turbo-1106", messages: conversation);
  //   await initializeConversation(conversation);
  //   await http.post(
  //     chatUri,
  //     headers: headers,
  //     body: request.toJson(),
  //   );
  // }


















//  static Future<String> getDrugInfo(
//       {String drugId = "f6f3c339-2c9d-4d07-14a1-6d6c7daf26c6"}) async {
//     try {
//       var url = Uri.parse(
//           "https://api.fda.gov/drug/label.json?search=set_id:$drugId&limit=1");  //buraya kullanıcının kayıt ettiği ilaçların idleri gönderilebilir.
//       var response = await http.get(url);
//       if (response.statusCode == 200) {
//         var data = json.decode(response.body);
//         var filteredData = {
//           for (var entry in data["results"][0].entries)
//             if ([
//               "brand_name",
//                 "generic_name",
//                 "active_ingredient",
//                 "boxed_warning",
//                 "indications_and_usage",
//                 "dosage_and_administration",
//                 "contraindications",
//                 "adverse_reactions",
//                 "drug_interactions",
//                 "warnings_and_cautions",
//                 "adverse_reactions",
//                 "description",
//                 "pediatric_use",
//                 "geriatric_use",
//                 "pregnancy",
//                 "lactation",
//                 "information_for_patients",
//             ].contains(entry.key))
//               entry.key: entry.value,
//         };
//         var filteredDataJson = json.encode(
//           filteredData,
//           toEncodable: (value) => value.toString(),
//         );
//         return filteredDataJson;
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }