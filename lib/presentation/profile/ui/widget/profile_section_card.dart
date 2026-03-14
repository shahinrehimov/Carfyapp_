part of '../page/profile_page.dart';

class _ProfileRowItem {
  final String label;
  final String icon;
  final VoidCallback? onTap;

  const _ProfileRowItem({required this.label, this.onTap, required this.icon});
}

class _ProfileSectionCard extends StatelessWidget {
  final String? title;
  final List<_ProfileRowItem> items;

  const _ProfileSectionCard({this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 2, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 16, bottom: 12),
              child: Text(
                title!,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: context.theme.colors.textDark),
              ),
            ),
          ...items.map(
            (item) => InkWell(
              onTap: item.onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: EdgeInsets.only(left: 24, right: 16, top: title == null ? 20 : 8, bottom: 20),
                child: Row(
                  children: [
                    SvgPicture.asset(item.icon, width: 24, height: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: context.theme.colors.textDark,
                          letterSpacing: 0.36,
                        ),
                      ),
                    ),
                    SvgPicture.asset(Assets.icons.chevronRight, width: 18, height: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
