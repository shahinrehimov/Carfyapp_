import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/domain/entities/products/search_suggestions.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/product_list/state/product_list_params_ui.dart';
import 'package:carfy/presentation/search/state/search_history_cubit.dart';
import 'package:carfy/presentation/search/state/search_suggestions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class SearchPage extends StatelessWidget implements AutoRouteWrapper {
  final String heroTag;
  final String? initialQuery;

  const SearchPage({super.key, this.heroTag = 'search_field_home', this.initialQuery});

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SearchHistoryCubit()..load()),
          BlocProvider(create: (_) => SearchSuggestionsCubit()),
        ],
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
  String _lastText = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      _controller.text = widget.initialQuery!;
      _lastText = widget.initialQuery!;
    }
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _controller.text;
    if (text == _lastText) return;
    _lastText = text;
    context.read<SearchSuggestionsCubit>().onSearchChanged(text);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
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

  void _navigateToProduct(SuggestionProduct product) {
    context.router.push(ProductDetailRoute(cpvUuid: product.uuid));
  }

  void _navigateToCategory(SuggestionCategory category) {
    final query = _controller.text.trim();
    final params = category.isSub
        ? ProductListPageParams(search: query.isNotEmpty ? query : null, subCategories: [category.slug])
        : ProductListPageParams(search: query.isNotEmpty ? query : null, categories: [category.slug]);
    context.router.push(ProductListRoute(params: params));
  }

  void _navigateToAllResults(String query) {
    final trimmed = query.trim();
    if (trimmed.isNotEmpty) {
      context.read<SearchHistoryCubit>().add(trimmed);
    }
    context.router.push(ProductListRoute(params: ProductListPageParams(search: trimmed)));
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
      body: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _controller,
        builder: (context, value, _) {
          if (value.text.trim().length >= 2) {
            return _SuggestionsBody(query: value.text.trim(), onSubmit: _submit, onProductTap: _navigateToProduct, onCategoryTap: _navigateToCategory, onAllResultsTap: _navigateToAllResults);
          }
          return _HistoryBody(onItemTap: _submit);
        },
      ),
    );
  }
}

class _HistoryBody extends StatelessWidget {
  final Future<void> Function(String) onItemTap;

  const _HistoryBody({required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchHistoryCubit, SearchHistoryState>(
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
                    onTap: () => onItemTap(item),
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
    );
  }
}

class _SuggestionsBody extends StatelessWidget {
  final String query;
  final Future<void> Function(String) onSubmit;
  final void Function(SuggestionProduct) onProductTap;
  final void Function(SuggestionCategory) onCategoryTap;
  final void Function(String) onAllResultsTap;

  const _SuggestionsBody({
    required this.query,
    required this.onSubmit,
    required this.onProductTap,
    required this.onCategoryTap,
    required this.onAllResultsTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchSuggestionsCubit, SearchSuggestionsState>(
      builder: (context, state) {
        final isLoading = state.status.maybeWhen(loading: () => true, orElse: () => false);

        return Column(
          children: [
            const Divider(height: 1, color: Color(0xFFEDEDED)),
            if (isLoading) const LinearProgressIndicator(minHeight: 2),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  if (state.suggestions != null && state.suggestions!.categories.isNotEmpty) ...[
                    _SectionHeader(title: context.localization.category.toUpperCase()),
                    ...state.suggestions!.categories.map(
                      (cat) => _CategoryItem(category: cat, onTap: () => onCategoryTap(cat)),
                    ),
                  ],
                  if (state.suggestions != null && state.suggestions!.products.isNotEmpty) ...[
                    _SectionHeader(title: context.localization.allProducts.toUpperCase()),
                    ...state.suggestions!.products.map(
                      (product) => _ProductItem(product: product, onTap: () => onProductTap(product)),
                    ),
                  ],
                  _AllResultsRow(query: query, onTap: () => onAllResultsTap(query)),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          color: context.theme.colors.black.withValues(alpha: 0.45),
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final SuggestionCategory category;
  final VoidCallback onTap;

  const _CategoryItem({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                category.displayTitle,
                style: TextStyle(
                  color: context.theme.colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Text(
              '(${category.productsCount})',
              style: TextStyle(
                color: context.theme.colors.black.withValues(alpha: 0.5),
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final SuggestionProduct product;
  final VoidCallback onTap;

  const _ProductItem({required this.product, required this.onTap});

  String _formatPrice(double price) => '${price.toStringAsFixed(2)} ₼';

  String? _sellersSubtitle() {
    final count = product.sellersCount;
    if (count <= 1) return null;
    if (product.hasOtherPrices) {
      return '$count sellers · from ${_formatPrice(product.minPrice)}';
    }
    return '$count sellers';
  }

  @override
  Widget build(BuildContext context) {
    final sellersText = _sellersSubtitle();

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _ProductImage(imageUrl: product.image),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.theme.colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (product.category != null && product.category!.displayTitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      product.category!.displayTitle,
                      style: TextStyle(
                        color: context.theme.colors.black.withValues(alpha: 0.5),
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (product.hasDiscount) ...[
                        Text(
                          _formatPrice(product.price),
                          style: TextStyle(
                            color: context.theme.colors.black.withValues(alpha: 0.4),
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: context.theme.colors.black.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        _formatPrice(product.priceFinal),
                        style: TextStyle(
                          color: context.theme.colors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (product.hasDiscount && product.discount != null && product.discountType == 'by_percentage') ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: context.theme.colors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '-${product.discount!.toInt()}%',
                            style: TextStyle(
                              color: context.theme.colors.error,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (sellersText != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      sellersText,
                      style: TextStyle(
                        color: context.theme.colors.black.withValues(alpha: 0.45),
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String? imageUrl;

  const _ProductImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 56,
        height: 56,
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(context),
              )
            : _placeholder(context),
      ),
    );
  }

  Widget _placeholder(BuildContext context) => Container(
        color: const Color(0xFFF2F2F2),
        child: Center(
          child: Icon(Icons.image_outlined, size: 24, color: context.theme.colors.black.withValues(alpha: 0.3)),
        ),
      );
}

class _AllResultsRow extends StatelessWidget {
  final String query;
  final VoidCallback onTap;

  const _AllResultsRow({required this.query, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 13, color: context.theme.colors.black),
                  children: [
                    TextSpan(text: '"$query" '),
                    TextSpan(
                      text: context.localization.searchResults,
                      style: TextStyle(color: context.theme.colors.primary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: context.theme.colors.primary),
          ],
        ),
      ),
    );
  }
}
