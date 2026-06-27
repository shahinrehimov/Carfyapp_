import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/domain/entities/car/car_color.dart';
import 'package:flutter/material.dart';

Color hexToColor(String hex) {
  final normalized = hex.replaceAll('#', '');
  final value = int.tryParse(normalized, radix: 16) ?? 0;
  return Color(0xFF000000 | value);
}

Future<Set<int>?> showCarColorPicker(
  BuildContext context, {
  required List<CarColor> colors,
  required String title,
  Set<int> initialSelected = const {},
  bool multiSelect = false,
  String? doneText,
}) {
  return showModalBottomSheet<Set<int>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
    builder: (_) => _CarColorPickerSheet(
      colors: colors,
      title: title,
      initialSelected: initialSelected,
      multiSelect: multiSelect,
      doneText: doneText,
    ),
  );
}

class _CarColorPickerSheet extends StatefulWidget {
  final List<CarColor> colors;
  final String title;
  final Set<int> initialSelected;
  final bool multiSelect;
  final String? doneText;

  const _CarColorPickerSheet({
    required this.colors,
    required this.title,
    required this.initialSelected,
    required this.multiSelect,
    required this.doneText,
  });

  @override
  State<_CarColorPickerSheet> createState() => _CarColorPickerSheetState();
}

class _CarColorPickerSheetState extends State<_CarColorPickerSheet> {
  late final Set<int> _selected = Set.from(widget.initialSelected);

  void _onTap(CarColor color) {
    if (widget.multiSelect) {
      setState(() {
        if (_selected.contains(color.id)) {
          _selected.remove(color.id);
        } else {
          _selected.add(color.id);
        }
      });
    } else {
      Navigator.of(context).pop({color.id});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 11, bottom: 8),
            child: Container(
              width: 54,
              height: 3,
              decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(100)),
            ),
          ),
          Text(
            widget.title,
            style: TextStyle(color: context.theme.colors.textDark, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: widget.colors.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                final color = widget.colors[index];
                final isSelected = _selected.contains(color.id);
                return GestureDetector(
                  onTap: () => _onTap(color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? context.theme.colors.primary.withValues(alpha: 0.08) : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: AnimatedScale(
                            scale: isSelected ? 1.06 : 1.0,
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutBack,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOut,
                              decoration: BoxDecoration(
                                color: hexToColor(color.hexCode),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFD8D7D7)),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: context.theme.colors.primary.withValues(alpha: 0.35),
                                          blurRadius: 14,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : const [],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 220),
                          style: TextStyle(
                            color: isSelected ? context.theme.colors.primary : context.theme.colors.textDark,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                          child: Text(
                            color.title,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.multiSelect)
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: MediaQuery.of(context).padding.bottom + 16),
              child: CustomButton(
                onPressed: () => Navigator.of(context).pop(_selected),
                text: widget.doneText ?? '',
                height: 48,
              ),
            ),
        ],
      ),
    );
  }
}

class CarColorPickerField extends StatelessWidget {
  final List<CarColor> colors;
  final CarColor? selected;
  final String hint;
  final String sheetTitle;
  final bool isLoading;
  final bool hasLoadError;
  final VoidCallback? onRetry;
  final String? errorText;
  final ValueChanged<CarColor> onSelected;

  const CarColorPickerField({
    super.key,
    required this.colors,
    required this.selected,
    required this.hint,
    required this.sheetTitle,
    required this.onSelected,
    this.isLoading = false,
    this.hasLoadError = false,
    this.onRetry,
    this.errorText,
  });

  Future<void> _open(BuildContext context) async {
    if (isLoading || hasLoadError || colors.isEmpty) return;
    final result = await showCarColorPicker(
      context,
      colors: colors,
      title: sheetTitle,
      initialSelected: selected != null ? {selected!.id} : const {},
    );
    if (result != null && result.isNotEmpty) {
      final picked = colors.firstWhere((c) => c.id == result.first);
      onSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _open(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: hasError ? context.theme.colors.error : context.theme.colors.border),
            ),
            child: Row(
              children: [
                if (selected != null) ...[
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: hexToColor(selected!.hexCode),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFD8D7D7)),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    selected?.title ?? hint,
                    style: TextStyle(
                      fontSize: 14,
                      color: selected != null ? context.theme.colors.textDark : context.theme.colors.textLight,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                if (isLoading)
                  const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                else if (hasLoadError)
                  GestureDetector(
                    onTap: onRetry,
                    child: Icon(Icons.refresh, color: context.theme.colors.textDark),
                  )
                else
                  Icon(Icons.arrow_drop_down, color: context.theme.colors.textDark),
              ],
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(errorText!, style: TextStyle(color: context.theme.colors.error, fontSize: 12)),
          ),
      ],
    );
  }
}

class CarColorMultiPickerField extends StatelessWidget {
  final List<CarColor> colors;
  final Set<int> selectedIds;
  final String hint;
  final String sheetTitle;
  final String doneText;
  final ValueChanged<Set<int>> onChanged;

  const CarColorMultiPickerField({
    super.key,
    required this.colors,
    required this.selectedIds,
    required this.hint,
    required this.sheetTitle,
    required this.doneText,
    required this.onChanged,
  });

  Future<void> _open(BuildContext context) async {
    if (colors.isEmpty) return;
    final result = await showCarColorPicker(
      context,
      colors: colors,
      title: sheetTitle,
      initialSelected: selectedIds,
      multiSelect: true,
      doneText: doneText,
    );
    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedIds.isNotEmpty;
    final selectedColors = hasSelection ? colors.where((c) => selectedIds.contains(c.id)).toList() : const <CarColor>[];
    return GestureDetector(
      onTap: () => _open(context),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: context.theme.colors.border),
        ),
        child: Row(
          children: [
            if (selectedColors.isNotEmpty) ...[_SwatchStack(colors: selectedColors), const SizedBox(width: 10)],
            Expanded(
              child: Text(
                hasSelection ? selectedColors.map((c) => c.title).join(', ') : hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: hasSelection ? context.theme.colors.textDark : context.theme.colors.textLight,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: context.theme.colors.textDark),
          ],
        ),
      ),
    );
  }
}

class _SwatchStack extends StatelessWidget {
  final List<CarColor> colors;
  static const _maxSwatches = 3;
  static const _swatchSize = 18.0;
  static const _overlap = 10.0;

  const _SwatchStack({required this.colors});

  @override
  Widget build(BuildContext context) {
    final visible = colors.take(_maxSwatches).toList();
    final width = _swatchSize + (visible.length - 1) * _overlap;
    return SizedBox(
      width: width,
      height: _swatchSize,
      child: Stack(
        children: [
          for (int i = 0; i < visible.length; i++)
            Positioned(
              left: i * _overlap,
              child: Container(
                width: _swatchSize,
                height: _swatchSize,
                decoration: BoxDecoration(
                  color: hexToColor(visible[i].hexCode),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
