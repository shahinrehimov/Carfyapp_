part of '../page/profile_page.dart';

class _ProfileMenuCard extends StatelessWidget {
  final String label;
  final String icon;
  final VoidCallback? onTap;

  const _ProfileMenuCard({required this.label, this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 87,
        decoration: BoxDecoration(
          color: context.theme.colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 2, offset: Offset(0, 2))],
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -30,
              right: -30,
              child: SvgPicture.asset(
                icon,
                width: 100,
                height: 100,
                colorFilter: ColorFilter.mode(const Color(0xFF00569C).withValues(alpha: 0.04), BlendMode.srcIn),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(icon, width: 32, height: 32),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: context.theme.colors.textDark),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
