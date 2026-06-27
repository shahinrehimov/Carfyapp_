import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/domain/entities/address/address.dart';
import 'package:carfy/domain/entities/payment/payment_method.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ── Address Card ──

class OrderConfirmAddressCard extends StatelessWidget {
  final Address? selectedAddress;
  final VoidCallback onTap;

  const OrderConfirmAddressCard({super.key, required this.selectedAddress, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          shadows: const [BoxShadow(color: Color(0x14000000), blurRadius: 2, offset: Offset(0, 2))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                selectedAddress == null ? Assets.icons.plusSquare : Assets.icons.map,
                colorFilter: ColorFilter.mode(context.theme.colors.primary, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: selectedAddress == null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.localization.orderConfirmAddAddress,
                          style: const TextStyle(
                            color: Color(0xFF292929),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                            letterSpacing: 0.42,
                          ),
                        ),
                        Text(
                          context.localization.orderConfirmAddAddressHint,
                          style: const TextStyle(
                            color: Color(0xFF717171),
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                            letterSpacing: 0.27,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      '${selectedAddress!.city.title},\n${selectedAddress!.addressLine1}',
                      style: const TextStyle(
                        color: Color(0xFF717171),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                        letterSpacing: 0.36,
                      ),
                    ),
            ),
            if (selectedAddress != null) ...[
              const SizedBox(width: 8),
              Text(
                context.localization.orderConfirmEditAddress,
                style: TextStyle(
                  color: context.theme.colors.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.36,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Payment Methods ──

class PaymentMethodsSection extends StatelessWidget {
  final List<PaymentMethod> methods;
  final PaymentMethod? selected;
  final ValueChanged<PaymentMethod> onSelected;

  const PaymentMethodsSection({super.key, required this.methods, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            context.localization.orderConfirmPaymentMethod,
            style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 12),
        for (int i = 0; i < methods.length; i++) ...[
          _PaymentMethodTile(
            method: methods[i],
            isSelected: selected?.value == methods[i].value,
            onTap: () => onSelected(methods[i]),
          ),
          if (i != methods.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodTile({required this.method, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          shadows: const [BoxShadow(color: Color(0x14000000), blurRadius: 2, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                method.label,
                style: const TextStyle(color: Color(0xFF242323), fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            _RadioDot(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool isSelected;

  const _RadioDot({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 18,
      height: 18,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF3696E7)),
          borderRadius: BorderRadius.circular(17),
        ),
      ),
      alignment: Alignment.center,
      child: AnimatedScale(
        scale: isSelected ? 1 : 0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutBack,
        child: Container(
          width: 12,
          height: 12,
          decoration: const ShapeDecoration(color: Color(0xFF3696E7), shape: OvalBorder()),
        ),
      ),
    );
  }
}

// ── Note Section ──

class NoteSection extends StatefulWidget {
  final String initialNote;
  final ValueChanged<String> onChanged;

  const NoteSection({super.key, required this.initialNote, required this.onChanged});

  @override
  State<NoteSection> createState() => _NoteSectionState();
}

class _NoteSectionState extends State<NoteSection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            context.localization.orderConfirmNote,
            style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _controller,
          hint: context.localization.orderConfirmNoteHint,
          onChanged: widget.onChanged,
          minLines: 3,
          maxLines: 5,
          fillColor: Colors.white,
          hasBorder: false,
          borderRadius: 16,
        ),
      ],
    );
  }
}

// ── Shimmers ──

class ItemsShimmer extends StatelessWidget {
  const ItemsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        height: 200,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class AddressShimmer extends StatelessWidget {
  const AddressShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        height: 60,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class PaymentMethodsShimmer extends StatelessWidget {
  const PaymentMethodsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Column(
        children: List.generate(
          2,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              height: 64,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ),
    );
  }
}
