part of '../page/my_addresses_page.dart';

class AddressItem extends StatelessWidget {
  final Address address;
  final bool isDeleting;
  final bool isSettingDefault;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onSetDefault;

  const AddressItem({
    super.key,
    required this.address,
    required this.isDeleting,
    required this.isSettingDefault,
    required this.onDelete,
    required this.onEdit,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 2, offset: Offset(0, 2))],
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pin icon
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: SvgPicture.asset(Assets.icons.map, width: 24, height: 24),
                ),
                const SizedBox(width: 8),
                Text(
                  address.addressType.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF292929)),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // Content
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text(
                        address.addressLine1,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF717171)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${address.city.title}, ${address.city.countryTitle}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF717171)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        address.phone,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF717171)),
                      ),
                    ],
                  ),
                ),
                // Actions
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        // Edit
                        GestureDetector(
                          onTap: onEdit,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: SvgPicture.asset(Assets.icons.edit3, width: 20, height: 20),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Delete
                        GestureDetector(
                          onTap: isDeleting ? null : onDelete,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: isDeleting
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: context.theme.colors.error),
                                  )
                                : SvgPicture.asset(Assets.icons.delete, width: 20, height: 20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Set default
                    GestureDetector(
                      onTap: address.isDefault || isSettingDefault ? null : onSetDefault,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: isSettingDefault
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator.adaptive())
                            : Icon(
                                address.isDefault ? Icons.star_rounded : Icons.star_border_rounded,
                                size: 22,
                                color: address.isDefault
                                    ? context.theme.colors.primary
                                    : context.theme.colors.textLight,
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
