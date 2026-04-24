import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/common/util/pref_util.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class SearchPage extends StatefulWidget {
  final String heroTag;
  final String? initialQuery;

  const SearchPage({super.key, this.heroTag = 'search_field_home', this.initialQuery});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  List<String> _history = [];

  static const _historyKey = 'search_history';
  static const _maxHistory = 10;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    if (widget.initialQuery != null) {
      _controller.text = widget.initialQuery!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadHistory() {
    final saved = PrefUtil.getStringList(_historyKey);
    if (saved != null) {
      setState(() => _history = saved);
    }
  }

  void _saveHistory(String query) {
    _history.remove(query);
    _history.insert(0, query);
    if (_history.length > _maxHistory) {
      _history = _history.sublist(0, _maxHistory);
    }
    PrefUtil.setStringList(_historyKey, _history);
  }

  void _clearHistory() {
    setState(() => _history = []);
    PrefUtil.remove(_historyKey);
  }

  void _submit(String query) {
    final trimmed = query.trim();
    if (trimmed.isNotEmpty) {
      _saveHistory(trimmed);
    }
    Navigator.pop(context, trimmed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 62,
        titleSpacing: 16,
        title: Row(
          children: [
            Expanded(
              child: Hero(
                tag: widget.heroTag,
                child: Material(
                  color: Colors.transparent,
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _controller,
                    builder: (context, value, _) {
                      return CustomTextField(
                        controller: _controller,
                        autoFocus: true,
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: _submit,
                        hint: context.localization.productSearchHint,
                        prefix: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.search, width: 20)),
                        suffix: value.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () => _controller.clear(),
                                child: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.closeSquare, width: 14)),
                              )
                            : null,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => context.router.maybePop(),
              child: Text(
                context.localization.searchCancel,
                style: const TextStyle(color: Color(0xFFFE764C), fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      body: _history.isEmpty
          ? const SizedBox.shrink()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1, color: Color(0xFFEDEDED)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        context.localization.searchHistory,
                        style: TextStyle(color: context.theme.colors.black, fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _clearHistory,
                        child: Text(
                          context.localization.searchDelete,
                          style: TextStyle(
                            color: context.theme.colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _history.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEDEDED)),
                    itemBuilder: (context, index) {
                      final item = _history[index];
                      return InkWell(
                        onTap: () => _submit(item),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            item,
                            style: TextStyle(
                              color: context.theme.colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
