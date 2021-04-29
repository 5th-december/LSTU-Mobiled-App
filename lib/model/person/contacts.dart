import 'package:json_annotation/json_annotation.dart';

part 'contacts.g.dart';

@JsonSerializable()
class Contacts
{
  final String phone;

  final String email;

  final String messenger;

  Contacts({this.phone, this.email, this.messenger});

  factory Contacts.fromJson(Map<String, dynamic> json) => _$ContactsFromJson(json);
  Map<String, dynamic> toJson() => _$ContactsToJson(this);
}