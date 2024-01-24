import 'package:json_annotation/json_annotation.dart';
part 'client_user.g.dart';


@JsonSerializable()
class ClientUser {
  ClientUser({
    required this.id,
    this.name,
    this.surname,
  });

  final String id;
  String? name;
  String? surname;


  factory ClientUser.fromJson(Map<String, dynamic> json) => _$ClientUserFromJson(json);

  Map<String, dynamic> toJson() => _$ClientUserToJson(this);
}
