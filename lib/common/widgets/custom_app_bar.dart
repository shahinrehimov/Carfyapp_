import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final double elevation;
  final ShapeBorder? shape;
  final bool centerTitle;
  final double? height;
  final Widget? flexibleSpace;

  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.elevation = 0,
    this.shape,
    this.centerTitle = true,
    this.height,
    this.flexibleSpace,
  });

  /// copyWith method
  CustomAppBar copyWith({
    String? title,
    Widget? leading,
    List<Widget>? actions,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    bool? centerTitle,
    double? height,
    Widget? flexibleSpace,
  }) {
    return CustomAppBar(
      title: title ?? this.title,
      leading: leading ?? this.leading,
      actions: actions ?? this.actions,
      elevation: elevation ?? this.elevation,
      shape: shape ?? this.shape,
      centerTitle: centerTitle ?? this.centerTitle,
      height: height ?? this.height,
      flexibleSpace: flexibleSpace ?? this.flexibleSpace
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      leading: leading,
      actions: actions,
      backgroundColor: context.theme.colors.secondary,
      elevation: elevation,
      shape: shape ?? const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))),
      centerTitle: centerTitle,
      flexibleSpace: flexibleSpace,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}

class CustomAppBarWhite extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;

  const CustomAppBarWhite({super.key, this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: TextStyle(fontWeight: FontWeight.w500, color: context.theme.colors.black, fontSize: 14),
            )
          : null,
      centerTitle: true,
      elevation: 0,
      backgroundColor: context.theme.colors.white,
      actions: actions,
      leading: InkWell(
        onTap: () => context.router.maybePop(),
        child: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.arrowNarrowLeft, width: 22)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
