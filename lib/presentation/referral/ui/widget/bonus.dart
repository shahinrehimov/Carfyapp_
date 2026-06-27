import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Bonus extends StatelessWidget {
  final double bonus;
  final bool loading;
  const Bonus({super.key, required this.bonus, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(colors: [Color(0xFF3696E7), Color(0xFF00569C)]),
            ),
          ),
          SvgPicture.asset(Assets.icons.bonusBgLeft, height: 200),
          Positioned(right: 0, child: SvgPicture.asset(Assets.icons.bonusBgRight, height: 200)),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  context.localization.referralBonuses,
                  style: TextStyle(fontSize: 18, color: context.theme.colors.white),
                ),
                const SizedBox(height: 12),
                if (loading)
                  const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                  )
                else
                  Text(
                    bonus.toStringAsFixed(2),
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: context.theme.colors.white),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
