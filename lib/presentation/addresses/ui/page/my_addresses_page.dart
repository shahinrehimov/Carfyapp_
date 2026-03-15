import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/common/widgets/confirmation_dialog.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/domain/entities/address/address.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/addresses/ui/page/address_form_bottom_sheet.dart';
import 'package:carfy/presentation/addresses/state/my_addresses/my_addresses_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

part '../widget/address_item.dart';

@RoutePage()
class MyAddressesPage extends StatelessWidget implements AutoRouteWrapper {
  const MyAddressesPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider(create: (_) => MyAddressesCubit()..init(), child: this);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MyAddressesCubit>();
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: CustomAppBarWhite(title: context.localization.profileMyAddresses),
      body: BlocListener<MyAddressesCubit, MyAddressesState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) => showStateStatusToast(context, state.status),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<MyAddressesCubit, MyAddressesState>(
                builder: (context, state) {
                  return state.status.maybeWhen(
                    loading: () => const _AddressListShimmer(),
                    orElse: () => state.addresses.isEmpty
                        ? const _EmptyAddressesView()
                        : _AddressList(addresses: state.addresses, cubit: cubit),
                  );
                },
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(67, 8, 67, 16),
                child: CustomButton(
                  onPressed: () async {
                    final saved = await showAddressFormBottomSheet(context);
                    if (saved) cubit.refresh();
                  },
                  backgroundColor: Colors.transparent,
                  outlineColor: context.theme.colors.primary,
                  color: context.theme.colors.primary,
                  prefix: SvgPicture.asset(
                    Assets.icons.plus,
                    height: 23,
                    colorFilter: ColorFilter.mode(context.theme.colors.primary, BlendMode.srcIn),
                  ),
                  text: context.localization.profileMyAddressesAddBtn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressList extends StatelessWidget {
  final List<Address> addresses;
  final MyAddressesCubit cubit;

  const _AddressList({required this.addresses, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: addresses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) => BlocBuilder<MyAddressesCubit, MyAddressesState>(
        buildWhen: (prev, curr) =>
            prev.deleteStatus[addresses[index].id] != curr.deleteStatus[addresses[index].id] ||
            prev.setDefaultStatus[addresses[index].id] != curr.setDefaultStatus[addresses[index].id] ||
            prev.addresses != curr.addresses,
        builder: (context, state) => AddressItem(
          address: addresses[index],
          isDeleting: state.deleteStatus[addresses[index].id] is StateStatusLoading,
          isSettingDefault: state.setDefaultStatus[addresses[index].id] is StateStatusLoading,
          onDelete: () => showConfirmationDialog(
            context: context,
            title: context.localization.addressDeleteConfirmTitle,
            description: context.localization.addressDeleteConfirmDescription,
            confirmText: context.localization.delete,
            cancelText: context.localization.cancel,
            onConfirm: () => cubit.deleteAddress(addresses[index].id),
          ),
          onEdit: () async {
            final saved = await showAddressFormBottomSheet(context, address: addresses[index]);
            if (saved) cubit.refresh();
          },
          onSetDefault: () => cubit.setDefault(addresses[index].id),
        ),
      ),
    );
  }
}

class _EmptyAddressesView extends StatelessWidget {
  const _EmptyAddressesView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.localization.profileMyAddressesEmpty,
        style: TextStyle(fontSize: 18, color: context.theme.colors.black),
      ),
    );
  }
}

class _AddressListShimmer extends StatelessWidget {
  const _AddressListShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, __) => ShimmerWrapper(
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: context.theme.colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
