import 'package:capsule_app/models/chatbot_message.dart';

class Choice {
  final int? index;
  final ChatBotMessage? message;
  final String? finishReason;

  Choice(this.index, this.message, this.finishReason);

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      json['index'],
      ChatBotMessage.fromJson(json['message']),
      json['finish_reason'],
    );
  }
}