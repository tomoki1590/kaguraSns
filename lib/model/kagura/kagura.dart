import 'package:freezed_annotation/freezed_annotation.dart';

part 'kagura.freezed.dart';
part 'kagura.g.dart';

@freezed
class Kagura with _$Kagura {
  const factory Kagura({
    required String id,
    @Default('') String uid,
  }) = _Kagura;
  factory Kagura.fromJson(Map<String, dynamic> json) =>
   _$KaguraFromJson(json);
}
