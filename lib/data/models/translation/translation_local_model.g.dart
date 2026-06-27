// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_local_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TranslationLocalModelAdapter extends TypeAdapter<TranslationLocalModel> {
  @override
  final typeId = 0;

  @override
  TranslationLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read()};
    return TranslationLocalModel(translations: (fields[0] as Map).cast<String, String>());
  }

  @override
  void write(BinaryWriter writer, TranslationLocalModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.translations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslationLocalModelAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
