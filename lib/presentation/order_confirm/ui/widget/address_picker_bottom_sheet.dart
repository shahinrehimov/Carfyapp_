import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/domain/entities/address/address.dart';
import 'package:carfy/presentation/addresses/state/my_addresses/my_addresses_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<Address?> showAddressPickerBottomSheet(BuildContext context, {Address? selectedAddress}) {
  return showModalBottomSheet<Address?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => MyAddressesCubit()..init(),
      child: _AddressPickerBottomSheet(selectedAddress: selectedAddress),
    ),
  );
}

class _AddressPickerBottomSheet extends StatelessWidget {
  final Address? selectedAddress;

  const _AddressPickerBottomSheet({this.selectedAddress});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 11, bottom: 8),
                child: Container(
                  width: 54,
                  height: 3,
                  decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(100)),
                ),
              ),
              Text(
                context.localization.orderConfirmSelectAddress,
                style: TextStyle(color: context.theme.colors.textDark, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<MyAddressesCubit, MyAddressesState>(
                  builder: (context, state) {
                    return state.status.maybeWhen(
                      loading: () => const _ShimmerList(),
                      orElse: () => _AddressList(
                        scrollController: scrollController,
                        addresses: state.addresses,
                        selectedAddressId: selectedAddress?.id,
                      ),
                    );
                  },
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop();
                      await context.router.push(MyAddressesRoute(openAddForm: true));
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: context.theme.colors.primary, width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 20, color: context.theme.colors.primary),
                          const SizedBox(width: 6),
                          Text(
                            context.localization.orderConfirmAddNewAddress,
                            style: TextStyle(
                              color: context.theme.colors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddressList extends StatelessWidget {
  final ScrollController scrollController;
  final List<Address> addresses;
  final int? selectedAddressId;

  const _AddressList({required this.scrollController, required this.addresses, this.selectedAddressId});

  @override
  Widget build(BuildContext context) {
    if (addresses.isEmpty) {
      return Center(
        child: Text(
          context.localization.profileMyAddressesEmpty,
          style: TextStyle(color: context.theme.colors.textLight, fontSize: 14),
        ),
      );
    }
    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: addresses.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEDEDED)),
      itemBuilder: (context, index) {
        final address = addresses[index];
        final isSelected = address.id == selectedAddressId;
        return InkWell(
          onTap: () => Navigator.of(context).pop(address),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected ? context.theme.colors.primary : context.theme.colors.textLight,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.addressType.title,
                        style: TextStyle(
                          color: context.theme.colors.textDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${address.city.title}, ${address.addressLine1}',
                        style: TextStyle(color: context.theme.colors.textLight, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ShimmerList extends StatelessWidget {
  const _ShimmerList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => ShimmerWrapper(
        child: Container(
          height: 56,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
