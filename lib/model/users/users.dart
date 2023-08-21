import 'package:freezed_annotation/freezed_annotation.dart';

part 'users.freezed.dart';
part 'users.g.dart';

@freezed
class Users with _$Users {
  const factory Users({
    @Default('') String name,
    @Default('') String email,
    @Default('') String uid,
    @Default('') String imgUrl,
    @Default([]) List<String>? block,
  }) = _Users;
  factory Users.fromJson(Map<String, dynamic> json) => _$UsersFromJson(json);
}
