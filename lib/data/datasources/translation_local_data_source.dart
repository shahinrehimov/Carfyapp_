import 'package:dartz/dartz.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

import '../models/translation/translation_local_model.dart';

abstract class TranslationLocalDataSource {
  Future<Unit> saveTranslations(TranslationLocalModel model, String languageCode);

  Future<TranslationLocalModel?> getTranslations(String languageCode);
}

@Injectable(as: TranslationLocalDataSource)
class TranslationLocalDataSourceImpl implements TranslationLocalDataSource {
  static const String _translationBoxName = 'translations';

  Future<Box<TranslationLocalModel>> get _translationBox => Hive.openBox('translates_box');

  @override
  Future<Unit> saveTranslations(TranslationLocalModel model, String languageCode) async {
    await (await _translationBox).put(languageCode, model);
    return unit;
  }

  @override
  Future<TranslationLocalModel?> getTranslations(String languageCode) async {
    return (await _translationBox).get(languageCode);
  }
}
