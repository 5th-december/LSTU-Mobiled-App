// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonAdapter extends TypeAdapter<Person> {
  @override
  final int typeId = 2;

  @override
  Person read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Person(
      id: fields[0] as String,
      surname: fields[1] as String,
      name: fields[2] as String,
      patronymic: fields[3] as String,
      birthday: fields[4] as DateTime,
      sex: fields[5] as String,
      phone: fields[6] as String,
      email: fields[7] as String,
      messenger: fields[8] as String,
      post: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Person obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.surname)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.patronymic)
      ..writeByte(4)
      ..write(obj.birthday)
      ..writeByte(5)
      ..write(obj.sex)
      ..writeByte(6)
      ..write(obj.phone)
      ..writeByte(7)
      ..write(obj.email)
      ..writeByte(8)
      ..write(obj.messenger)
      ..writeByte(9)
      ..write(obj.post);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) {
  return Person(
    id: json['uoid'] as String,
    surname: json['lname'] as String,
    name: json['fname'] as String,
    patronymic: json['patronymic'] as String,
    birthday:
        json['bday'] == null ? null : DateTime.parse(json['bday'] as String),
    sex: json['sex'] as String,
    phone: json['phone'] as String,
    email: json['email'] as String,
    messenger: json['messenger'] as String,
    post: json['post'] as String,
  );
}

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'uoid': instance.id,
      'lname': instance.surname,
      'fname': instance.name,
      'patronymic': instance.patronymic,
      'bday': instance.birthday?.toIso8601String(),
      'sex': instance.sex,
      'phone': instance.phone,
      'email': instance.email,
      'messenger': instance.messenger,
      'post': instance.post,
    };
