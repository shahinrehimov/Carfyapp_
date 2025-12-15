import 'package:flutter/material.dart';

class PaginationScrollWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onLoadMore;
  final double threshold;

  const PaginationScrollWrapper({
    super.key,
    required this.child,
    required this.onLoadMore,
    this.threshold = 20,
  });

  @override
  State<PaginationScrollWrapper> createState() => _PaginationScrollWrapperState();
}

class _PaginationScrollWrapperState extends State<PaginationScrollWrapper> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      widget.onLoadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - widget.threshold);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: widget.child,
    );
  }
}