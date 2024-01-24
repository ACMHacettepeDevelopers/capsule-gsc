// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientUser _$ClientUserFromJson(Map<String, dynamic> json) => ClientUser(
      id: json['id'] as String,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
    );

Map<String, dynamic> _$ClientUserToJson(ClientUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'surname': instance.surname,
    };
