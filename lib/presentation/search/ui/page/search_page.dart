import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/search/state/search_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class SearchPage extends StatelessWidget implements AutoRouteWrapper {
  final String heroTag;
  final String? initialQuery;

  const SearchPage({super.key, this.heroTag = 'search_field_home', this.initialQuery});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (_) => SearchHistoryCubit()..load(),
        child: this,
      );

  @override
  Widget build(BuildContext context) {
    return _SearchPageBody(heroTag: heroTag, initialQuery: initialQuery);
  }
}

class _SearchPageBody extends StatefulWidget {
  final String heroTag;
  final String? initialQuery;

  const _SearchPageBody({required this.heroTag, this.initialQuery});

  @override
  State<_SearchPageBody> createState() => _SearchPageBodyState();
}

class _SearchPageBodyState extends State<_SearchPageBody> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      _controller.text = widget.initialQuery!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit(String query) async {
    final trimmed = query.trim();
    if (trimmed.isNotEmpty) {
      await context.read<SearchHistoryCubit>().add(trimmed);
    }
    if (mounted) Navigator.pop(context, trimmed);
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
      body: BlocBuilder<SearchHistoryCubit, SearchHistoryState>(
        buildWhen: (prev, curr) => prev.history != curr.history,
        builder: (context, state) {
          if (state.history.isEmpty) return const SizedBox.shrink();
          return Column(
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
                      onTap: () => context.read<SearchHistoryCubit>().clear(),
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
                  itemCount: state.history.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEDEDED)),
                  itemBuilder: (context, index) {
                    final item = state.history[index];
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
          );
        },
      ),
    );
  }
}
