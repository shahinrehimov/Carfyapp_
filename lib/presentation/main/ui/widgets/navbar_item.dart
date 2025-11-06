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
  late AnimationController controller;
  late Animation<double> _fadeInFadeOut;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _fadeInFadeOut = Tween<double>(begin: 1, end: 0.5).animate(controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          if (widget.onTap != null) {
            widget.onTap!();
          }
          controller.forward();
          await Future.delayed(const Duration(milliseconds: 200));
          controller.reverse();
        },
        behavior: HitTestBehavior.opaque,
        child: FadeTransition(
          opacity: _fadeInFadeOut,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  widget.image,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    widget.isActive ? context.theme.colors.secondary : context.theme.colors.textDark,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(height: 9),
              Text(
                widget.text,
                style: TextStyle(
                  color: widget.isActive ? context.theme.colors.secondary : context.theme.colors.textDark,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
