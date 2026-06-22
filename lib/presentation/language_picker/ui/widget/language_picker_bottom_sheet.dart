import 'package:carfy/common/enums/language.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/domain/entities/translation/app_language.dart';
import 'package:carfy/presentation/app/state/localization/localization_cubit.dart';
import 'package:carfy/presentation/language_picker/state/language_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showLanguagePickerBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => LanguagePickerCubit()..load(),
      child: const _LanguagePickerBottomSheet(),
    ),
  );
}

class _LanguagePickerBottomSheet extends StatelessWidget {
  const _LanguagePickerBottomSheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.3,
      maxChildSize: 0.7,
      expand: false,
      builder: (context, scrollController) {
        return Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 11, bottom: 8),
                child: Container(
                  width: 54,
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              Text(
                context.localization.profileLanguage,
                style: TextStyle(color: context.theme.colors.textDark, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<LanguagePickerCubit, LanguagePickerState>(
                  builder: (context, state) {
                    return state.status.maybeWhen(
                      loading: () => const _ShimmerList(),
                      success: () => _LanguageList(scrollController: scrollController, languages: state.languages),
                      orElse: () => _LanguageList(scrollController: scrollController, languages: state.languages),
                    );
                  },
                ),
              ),
              const SafeArea(top: false, child: SizedBox(height: 8)),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageList extends StatelessWidget {
  final ScrollController scrollController;
  final List<AppLanguage> languages;

  const _LanguageList({required this.scrollController, required this.languages});

  @override
  Widget build(BuildContext context) {
    if (languages.isEmpty) {
      return const SizedBox.shrink();
    }
    final currentCode = context.read<LocalizationCubit>().state.appLanguage.locale.languageCode;
    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: languages.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEDEDED)),
      itemBuilder: (context, index) {
        final lang = languages[index];
        final isSelected = lang.key == currentCode;
        final display = Language.fromValue(lang.key).displayName;
        return InkWell(
          onTap: () {
            if (!isSelected) {
              context.read<LocalizationCubit>().changeLanguage(lang.key);
            }
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected ? context.theme.colors.primary : context.theme.colors.textLight,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    display,
                    style: TextStyle(
                      color: context.theme.colors.textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ShimmerList extends StatelessWidget {
  const _ShimmerList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => ShimmerWrapper(
        child: Container(
          height: 44,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
