// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// ignore: non_constant_identifier_names
_$_Users _$$_UsersFromJson(Map<String, dynamic> json) => _$_Users(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      block:
          (json['block'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

// ignore: non_constant_identifier_names
Map<String, dynamic> _$$_UsersToJson(_$_Users instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'uid': instance.uid,
      'block': instance.block,
    };
