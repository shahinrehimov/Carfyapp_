import 'package:carfy/common/constants/preference_keys.dart';
import 'package:carfy/common/util/pref_util.dart';
import 'package:injectable/injectable.dart';

abstract class SearchHistoryLocalDataSource {
  Future<List<String>> getHistory();
  Future<void> add(String query);
  Future<void> remove(String query);
  Future<void> clear();
}

@Injectable(as: SearchHistoryLocalDataSource)
class SearchHistoryLocalDataSourceImpl extends SearchHistoryLocalDataSource {
  static const _maxItems = 20;

  @override
  Future<List<String>> getHistory() async {
    return PrefUtil.getStringList(AppPreferenceKeys.searchHistory) ?? const [];
  }

  @override
  Future<void> add(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final current = await getHistory();
    final updated = [trimmed, ...current.where((q) => q != trimmed)].take(_maxItems).toList();
    await PrefUtil.setStringList(AppPreferenceKeys.searchHistory, updated);
  }

  @override
  Future<void> remove(String query) async {
    final current = await getHistory();
    final updated = current.where((q) => q != query).toList();
    await PrefUtil.setStringList(AppPreferenceKeys.searchHistory, updated);
  }

  @override
  Future<void> clear() async {
    await PrefUtil.remove(AppPreferenceKeys.searchHistory);
  }
}
