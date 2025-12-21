import 'package:carfy/common/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> titles;
  final List<Widget> children;

  const CustomTabBar({super.key, required this.titles, required this.children});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  TabBarCornerPosition _cornerPosition = TabBarCornerPosition.right;

  @override
  void initState() {
    super.initState();
    int length = widget.titles.length;
    _tabController = TabController(length: length, vsync: this);

    _tabController.addListener(() {
      int position = _tabController.index;
      if (position == 0) {
        setState(() {
          _cornerPosition = TabBarCornerPosition.right;
        });
      } else if (position == length - 1) {
        setState(() {
          _cornerPosition = TabBarCornerPosition.left;
        });
      } else {
        setState(() {
          _cornerPosition = TabBarCornerPosition.both;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFCEE5F8).withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            padding: EdgeInsets.zero,
            indicatorPadding: EdgeInsets.zero,
            indicatorWeight: 0,
            indicator: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Color(0x29000000), offset: Offset(0, 1), blurRadius: 8, spreadRadius: 0)],
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
            splashBorderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            labelStyle: TextStyle(color: context.theme.colors.primary, fontWeight: FontWeight.w500, fontSize: 14),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, color: Color(0xFF313131), fontSize: 14),
            tabs: widget.titles.map((e) => Tab(text: e, height: 60)).toList(),
          ),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  const BoxShadow(color: Color(0x29000000), offset: Offset(0, 10), blurRadius: 10, spreadRadius: 0),
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(40),
                  bottomRight: const Radius.circular(40),
                  topLeft: Radius.circular(
                    _cornerPosition == TabBarCornerPosition.left || _cornerPosition == TabBarCornerPosition.both
                        ? 40
                        : 0,
                  ),
                  topRight: Radius.circular(
                    _cornerPosition == TabBarCornerPosition.right || _cornerPosition == TabBarCornerPosition.both
                        ? 40
                        : 0,
                  ),
                ),
              ),
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: widget.children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum TabBarCornerPosition { left, right, both }
