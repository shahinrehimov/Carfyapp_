import 'package:carfy/common/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final double elevation;
  final ShapeBorder? shape;
  final bool centerTitle;
  final double? height;

  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.elevation = 0,
    this.shape,
    this.centerTitle = true,
    this.height,
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
  }) {
    return CustomAppBar(
      title: title ?? this.title,
      leading: leading ?? this.leading,
      actions: actions ?? this.actions,
      elevation: elevation ?? this.elevation,
      shape: shape ?? this.shape,
      centerTitle: centerTitle ?? this.centerTitle,
      height: height ?? this.height,
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
      shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))),
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}
