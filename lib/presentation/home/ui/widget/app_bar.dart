part of '../page/home_page.dart';

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SvgPicture.asset(Assets.icons.locationIcon),
                      const SizedBox(width: 6),
                      Text('Baki', style: TextStyle(color: context.theme.colors.white)),
                    ],
                  ),
                ),
                SvgPicture.asset(Assets.icons.logoWhite),
                Expanded(
                  child: Align(alignment: Alignment.centerRight, child: SvgPicture.asset(Assets.icons.notification)),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: TextEditingController(),
                    fillColor: Colors.white,
                    hint: context.localization.search,
                    prefix: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.search, width: 20)),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => FilterBottomSheet.show(context),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: context.theme.colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(child: SvgPicture.asset(Assets.icons.filters)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
