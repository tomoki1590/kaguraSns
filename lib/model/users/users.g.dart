// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Users _$$_UsersFromJson(Map<String, dynamic> json) => _$_Users(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      imgUrl: json['imgUrl'] as String? ?? '',
      block:
          (json['block'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$_UsersToJson(_$_Users instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'uid': instance.uid,
      'imgUrl': instance.imgUrl,
      'block': instance.block,
    };
