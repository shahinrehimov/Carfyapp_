import 'package:carfy/common/extensions/price_extension.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/domain/entities/products/product_show.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/app/state/basket_manager/basket_manager_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductBottomBar extends StatelessWidget {
  final ProductShow product;

  const ProductBottomBar({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: context.theme.colors.white,
        border: Border(top: BorderSide(color: const Color(0xFFEDEDED))),
        boxShadow: const [BoxShadow(color: Color(0x28000000), blurRadius: 16)],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.hasDiscount)
                Text(
                  product.price.manatFormatted,
                  style: TextStyle(
                    color: context.theme.colors.darkGray,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              Text(
                product.priceFinal.manatFormatted,
                style: TextStyle(color: context.theme.colors.primary, fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: BlocBuilder<BasketManagerCubit, BasketManagerState>(
              buildWhen: (prev, curr) {
                final cpvUuid = product.seller?.uuid;
                if (cpvUuid == null) return false;
                return prev.isLoading(cpvUuid) != curr.isLoading(cpvUuid);
              },
              builder: (context, state) {
                final cpvUuid = product.seller?.uuid;
                final isLoading = cpvUuid != null && state.isLoading(cpvUuid);
                return CustomButton(
                  onPressed: isLoading || cpvUuid == null
                      ? () {}
                      : () => context.read<BasketManagerCubit>().addToBasket(cpvUuid),
                  loading: isLoading,
                  text: context.localization.addToBasket,
                  height: 48,
                  prefix: isLoading
                      ? null
                      : SvgPicture.asset(
                          Assets.icons.mainBasket,
                          width: 24,
                          colorFilter: ColorFilter.mode(context.theme.colors.white, BlendMode.srcIn),
                        ),
                  prefixPadding: 8,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
