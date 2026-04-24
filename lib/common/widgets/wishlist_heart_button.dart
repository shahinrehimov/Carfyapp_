import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/app/state/wishlist_manager/wishlist_manager_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Heart button with a scale-pop animation on tap and a smooth
/// crossfade between the outlined/filled states when the wishlist
/// status changes.
class WishlistHeartButton extends StatefulWidget {
  final String? cpvUuid;
  final double size;

  const WishlistHeartButton({
    super.key,
    required this.cpvUuid,
    this.size = 24,
  });

  @override
  State<WishlistHeartButton> createState() => _WishlistHeartButtonState();
}

class _WishlistHeartButtonState extends State<WishlistHeartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
    TweenSequenceItem(tween: Tween(begin: 1.35, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 50),
  ]).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    final uuid = widget.cpvUuid;
    if (uuid == null) return;
    _controller.forward(from: 0);
    context.read<WishlistManagerCubit>().toggle(uuid);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.cpvUuid != null ? _onTap : null,
      child: BlocBuilder<WishlistManagerCubit, WishlistManagerState>(
        buildWhen: (prev, curr) {
          final cpvUuid = widget.cpvUuid;
          if (cpvUuid == null) return false;
          return prev.wishlistIds.contains(cpvUuid) != curr.wishlistIds.contains(cpvUuid);
        },
        builder: (context, state) {
          final cpvUuid = widget.cpvUuid;
          final isWishlisted = cpvUuid != null && state.wishlistIds.contains(cpvUuid);
          return ScaleTransition(
            scale: _scale,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              ),
              child: SvgPicture.asset(
                isWishlisted ? Assets.icons.heartFilled : Assets.icons.heart,
                key: ValueKey(isWishlisted),
                width: widget.size,
                height: widget.size,
              ),
            ),
          );
        },
      ),
    );
  }
}
