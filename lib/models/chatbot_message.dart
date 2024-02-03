class ChatBotMessage {
  final String? role;
  final String? content;

  ChatBotMessage({this.role, this.content});

  factory ChatBotMessage.fromJson(Map<String, dynamic> json) {
    return ChatBotMessage(
      role: json['role'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }
}