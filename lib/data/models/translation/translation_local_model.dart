import 'package:hive_ce/hive.dart';

part 'translation_local_model.g.dart';

@HiveType(typeId: 0)
class TranslationLocalModel extends HiveObject {
  @HiveField(0)
  final Map<String, String> translations;

  TranslationLocalModel({required this.translations});
}
