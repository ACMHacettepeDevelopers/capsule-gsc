import 'dart:convert';
import 'package:capsule_app/models/chat_response.dart';
import 'package:http/http.dart' as http;
import "package:capsule_app/API_KEY.dart";
import "package:capsule_app/models/chat_request.dart";
import 'package:capsule_app/models/chatbot_message.dart';

class ChatBotService {
  static final Uri chatUri =
      Uri.parse('https://api.openai.com/v1/chat/completions');
  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${ApiKey.openAIApiKey}',
  };
  final ChatBotService instance = ChatBotService.constructor();
  ChatBotService.constructor() {
    initializeChat("hello");
  }

  Future<void> initializeChat(String userInput) async {
    ChatRequest request = ChatRequest(model: "gpt-3.5-turbo", maxTokens: 150, messages: [ChatBotMessage(role: "system", content: userInput)]);
    http.Response response = await http.post(
        chatUri,
        headers: headers,
        body: request.toJson(),
      );

    ChatResponse chatResponse = ChatResponse.fromResponse(response);
      print(chatResponse.choices?[0].message?.content);
     
  }

  Future<void> initializeChatBot() async {
    final drugInfo = await getDrugInfo();
    ChatRequest initialRequest =
        ChatRequest(model: "gpt-3.5-turbo", maxTokens: 150, messages: [
      ChatBotMessage(
        role: "system",
        content:
            "You are a pharmacist. You are helping a patient understand their medication. Do not mention how the information is obtained. Do not answer questions that are not related to the medication. Answer unrelated questions with 'I can only answer questions about your medication.'. Do not use any other sources of information.",
      )
    ]);
    ChatRequest initialRequest2 = ChatRequest(
        model: "gpt-3.5-turbo",
        maxTokens: 150,
        messages: [
          ChatBotMessage(role: "system", content: "Drug info: $drugInfo")
        ]);
    await http.post(
      chatUri,
      headers: headers,
      body: initialRequest.toJson(),
    );
    await http.post(
      chatUri,
      headers: headers,
      body: initialRequest2.toJson(),
    );
  }

  Future<String> getDrugInfo(
      {String drugId = "f6f3c339-2c9d-4d07-14a1-6d6c7daf26c6"}) async {
    try {
      var url = Uri.parse(
          "https://api.fda.gov/drug/label.json?search=set_id:$drugId&limit=1");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var filteredData = {
          for (var entry in data["results"][0].entries)
            if (![
              "adverse_reactions_table",
              "description_table",
              "indications_and_usage_table",
              "dosage_and_administration_table",
              "drug_interactions_table",
              "clinical_pharmacology_table",
              "clinical_studies_table",
              "contraindications_table",
              "how_supplied_table",
              "information_for_patients_table",
              "set_id",
              "id",
              "openfda",
              "effective_time",
              "version",
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
