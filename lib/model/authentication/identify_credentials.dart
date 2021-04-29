import 'package:json_annotation/json_annotation.dart';

part 'identify_credentials.g.dart';

@JsonSerializable()
class IdentifyCredentials {
  final String username;

  @JsonKey(name: 'enter_year')
  final int enterYear;

  @JsonKey(name: 'z_book_number')
  final String zBookNumber;

  IdentifyCredentials({this.username, this.enterYear, this.zBookNumber});

  factory IdentifyCredentials.fromJson(Map<String, dynamic> json) =>
      _$IdentifyCredentialsFromJson(json);
  Map<String, dynamic> toJson() => _$IdentifyCredentialsToJson(this);
}
