import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductContactSection extends StatelessWidget {
  const ProductContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(color: const Color(0xFFE8F4FF), borderRadius: BorderRadius.circular(32)),
            child: Column(
              children: [
                SvgPicture.asset(Assets.icons.writeCarfy, width: 40, height: 40),
                const SizedBox(height: 8),
                Text(
                  context.localization.contactUs,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.theme.colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 296,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: context.theme.colors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    ),
                    child: Text(
                      context.localization.writeToCarfy,
                      style: TextStyle(color: context.theme.colors.primary, fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(onPressed: () {}, text: context.localization.callCarfy, height: 48),
        ],
      ),
    );
  }
}
