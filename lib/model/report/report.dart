import 'package:freezed_annotation/freezed_annotation.dart';

part 'report.freezed.dart';
part 'report.g.dart';

@freezed
class Report with _$Report {
  const factory Report({
    @Default('') String docId,
  }) = _Report;
  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
}
