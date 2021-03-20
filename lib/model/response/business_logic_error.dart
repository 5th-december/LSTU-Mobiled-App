import 'package:json_annotation/json_annotation.dart';

part 'business_logic_error.g.dart';

@JsonSerializable()
class BusinessLogicError
{
  final String code;
  final String systemMessage;
  final String userMessage;
  final Map<String, String> errorProperties;

  BusinessLogicError({this.code, this.systemMessage, this.userMessage, this.errorProperties});

  Map<String, dynamic> toJson() => _$BusinessLogicErrorToJson(this);
  factory BusinessLogicError.fromJson(Map<String, dynamic> json) => _$BusinessLogicErrorFromJson(json);
}