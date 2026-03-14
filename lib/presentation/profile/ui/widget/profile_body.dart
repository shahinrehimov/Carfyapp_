part of '../page/profile_page.dart';

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _ProfileMenuCard(label: context.localization.profileMyCars, icon: Assets.icons.carHatchback, onTap: () {}),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ProfileMenuCard(label: context.localization.profileMyOrders, icon: Assets.icons.box, onTap: () {}),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _ProfileMenuCard(label: context.localization.profileMyAddresses, icon: Assets.icons.addressPinLocation, onTap: () {}),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ProfileMenuCard(label: context.localization.profileReferrals, icon: Assets.icons.saleSquare, onTap: () {}),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ProfileSectionCard(
            title: context.localization.profileSettings,
            items: [_ProfileRowItem(label: context.localization.profileActiveSessions, icon: Assets.icons.mobile, onTap: () {})],
          ),
          const SizedBox(height: 8),
          _ProfileSectionCard(
            title: context.localization.profileLanguage,
            items: [_ProfileRowItem(label: context.localization.profileCurrentLanguage, icon: Assets.icons.globe2, onTap: () {})],
          ),
          const SizedBox(height: 8),
          _ProfileSectionCard(
            items: [_ProfileRowItem(label: context.localization.profileSupport, icon: Assets.icons.support, onTap: () {})],
          ),
        ],
      ),
    );
  }
}
