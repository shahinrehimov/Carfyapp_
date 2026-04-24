import 'package:flutter/cupertino.dart';

class PullToRefreshWrapper extends StatelessWidget {
  final Future<void> Function() onRefresh;

  final Widget child;

  const PullToRefreshWrapper({super.key, required this.onRefresh, required this.child});

  @override
  Widget build(BuildContext context) {
    final isScrollable = child is ScrollView || child is SingleChildScrollView || child is CustomScrollView;

    if (isScrollable) {
      return CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: onRefresh),
          SliverFillRemaining(child: child),
        ],
      );
    } else {
      return CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: onRefresh),
          SliverToBoxAdapter(child: child),
        ],
      );
    }
  }
}
