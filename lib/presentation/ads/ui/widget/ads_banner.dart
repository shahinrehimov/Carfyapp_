import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/domain/entities/advertisements/advertisement.dart';
import 'package:carfy/presentation/ads/state/ads_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class AdsBanner extends StatelessWidget {
  final double height;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double borderRadius;

  const AdsBanner({
    super.key,
    this.height = 120,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdsCubit()..load(),
      child: _AdsBannerView(height: height, padding: padding, borderRadius: borderRadius, margin: margin),
    );
  }
}

class _AdsBannerView extends StatelessWidget {
  final double height;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double borderRadius;

  const _AdsBannerView({required this.height, required this.padding, required this.borderRadius, required this.margin});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsCubit, AdsState>(
      builder: (context, state) {
        return state.status.maybeWhen(
          success: () {
            if (state.ads.isEmpty) return const SizedBox.shrink();
            return _AdsPager(
              ads: state.ads,
              height: height,
              borderRadius: borderRadius,
              padding: padding,
              margin: margin,
            );
          },
          orElse: () => _AdsLoading(height: height, padding: padding, borderRadius: borderRadius, margin: margin),
          failure: (_) => const SizedBox.shrink(),
          networkFailure: () => const SizedBox.shrink(),
          serverFailure: () => const SizedBox.shrink(),
        );
      },
    );
  }
}

class _AdsPager extends StatefulWidget {
  final List<Advertisement> ads;
  final double height;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const _AdsPager({
    required this.ads,
    required this.height,
    required this.borderRadius,
    required this.padding,
    required this.margin,
  });

  @override
  State<_AdsPager> createState() => _AdsPagerState();
}

class _AdsPagerState extends State<_AdsPager> {
  static const Duration _autoScrollInterval = Duration(seconds: 5);
  static const Duration _autoScrollAnimation = Duration(milliseconds: 500);

  final PageController _controller = PageController();
  int _currentIndex = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    if (widget.ads.length <= 1) return;
    _autoScrollTimer = Timer.periodic(_autoScrollInterval, (_) {
      if (!mounted || !_controller.hasClients) return;
      final next = (_currentIndex + 1) % widget.ads.length;
      _controller.animateToPage(next, duration: _autoScrollAnimation, curve: Curves.easeOutCubic);
    });
  }

  void _onUserInteraction() {
    // Pause and restart so the next auto-advance isn't immediate after a swipe.
    _startAutoScroll();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: SizedBox(
        height: widget.height,
        child: Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (n) {
                if (n is UserScrollNotification && n.direction != ScrollDirection.idle) {
                  _onUserInteraction();
                }
                return false;
              },
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.ads.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (context, index) =>
                    _AdCard(ad: widget.ads[index], borderRadius: widget.borderRadius, padding: widget.padding),
              ),
            ),
            if (widget.ads.length > 1)
              Positioned(
                left: 0,
                right: 0,
                bottom: 16,
                child: _AdsIndicator(count: widget.ads.length, currentIndex: _currentIndex),
              ),
          ],
        ),
      ),
    );
  }
}

class _AdCard extends StatelessWidget {
  final Advertisement ad;
  final double borderRadius;
  final EdgeInsets padding;

  const _AdCard({required this.ad, required this.borderRadius, required this.padding});

  Future<void> _openLink() async {
    final uri = Uri.tryParse(ad.link);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: GestureDetector(
          onTap: _openLink,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(imageUrl: ad.imageUrl!, fit: BoxFit.cover),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withValues(alpha: 0.15), Colors.black.withValues(alpha: 0.55)],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 40,
                child: Text(
                  ad.title,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700, height: 1.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdsIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _AdsIndicator({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

class _AdsLoading extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final EdgeInsets margin;

  const _AdsLoading({required this.height, required this.padding, required this.borderRadius, required this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: ShimmerWrapper(
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: context.theme.colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
