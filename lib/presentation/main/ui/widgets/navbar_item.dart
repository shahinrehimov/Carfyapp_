import 'package:carfy/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBarItem extends StatefulWidget {
  const NavBarItem({super.key, this.onTap, required this.image, required this.text, this.isActive = false});

  final void Function()? onTap;
  final String image;
  final String text;
  final bool isActive;

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> with SingleTickerProviderStateMixin {
  late final AnimationController _tapController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );

  late final Animation<double> _tapScale = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: 0.85).chain(CurveTween(curve: Curves.easeOut)),
      weight: 40,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 0.85, end: 1.12).chain(CurveTween(curve: Curves.easeOut)),
      weight: 30,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.12, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
      weight: 30,
    ),
  ]).animate(_tapController);

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  void _onTap() {
    widget.onTap?.call();
    _tapController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = context.theme.colors.secondary;
    final inactiveColor = context.theme.colors.textDark;
    final targetColor = widget.isActive ? activeColor : inactiveColor;

    return Expanded(
      child: GestureDetector(
        onTap: _onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _tapScale,
              child: TweenAnimationBuilder<Color?>(
                duration: const Duration(milliseconds: 260),
                tween: ColorTween(begin: targetColor, end: targetColor),
                builder: (context, color, _) => SvgPicture.asset(
                  widget.image,
                  height: 24,
                  colorFilter: ColorFilter.mode(color ?? inactiveColor, BlendMode.srcIn),
                ),
              ),
            ),
            const SizedBox(height: 9),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 260),
              style: TextStyle(
                color: targetColor,
                fontSize: 10,
                fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
              ),
              child: Text(widget.text),
            ),
          ],
        ),
      ),
    );
  }
}
