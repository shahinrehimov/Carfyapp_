part of '../page/my_cars_page.dart';

class CarItem extends StatelessWidget {
  final UserCar car;
  final bool isDeleting;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onSearch;

  const CarItem({
    super.key,
    required this.car,
    required this.isDeleting,
    required this.onDelete,
    required this.onEdit,
    required this.onSearch,
  });

  String get _details {
    final parts = <String>[
      car.year.toString(),
      if (car.fuelType != null) car.fuelType!.title,
      if (car.engineVolume != null) car.engineVolume!.title,
      if (car.engineNumber != null && car.engineNumber!.isNotEmpty) car.engineNumber!,
      if (car.vinNumber != null && car.vinNumber!.isNotEmpty) car.vinNumber!,
    ];
    return parts.join(', ');
  }

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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 11, 13, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Photo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(43),
                        child: car.photo != null
                            ? CachedNetworkImage(imageUrl: car.photo!, width: 52, height: 52, fit: BoxFit.cover)
                            : Container(
                                width: 52,
                                height: 52,
                                color: context.theme.colors.bg,
                                child: Center(child: SvgPicture.asset(Assets.icons.carHatchback, width: 32, height: 32)),
                              ),
                      ),
                      const SizedBox(width: 10),
                      // Name
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            '${car.brand.title} ${car.brandModel.title}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: context.theme.colors.textDark,
                            ),
                          ),
                        ),
                      ),
                      // Edit icon
                      GestureDetector(
                        onTap: onEdit,
                        child: Padding(padding: const EdgeInsets.all(4), child: SvgPicture.asset(Assets.icons.edit3)),
                      ),
                      // Delete icon
                      GestureDetector(
                        onTap: isDeleting ? null : onDelete,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: isDeleting
                              ? SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: context.theme.colors.error),
                                )
                              : SvgPicture.asset(Assets.icons.delete),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Details
                  Text(
                    _details,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF717171)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFEDEDED)),
            // Search button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: GestureDetector(
                onTap: onSearch,
                child: Container(
                  width: 264,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF3696E7), Color(0xFF00569C)]),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                    child: Text(
                      context.localization.profileMyCarsSearchBtn,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
