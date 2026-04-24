import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/state/field_validation_state.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/contact/state/contact_us_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class ContactUsPage extends StatefulWidget implements AutoRouteWrapper {
  const ContactUsPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider(create: (_) => ContactUsCubit()..init(), child: this);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  bool _canSubmit(ContactUsState state) {
    if (state.user == null) return false;
    return _messageController.text.trim().isNotEmpty;
  }

  void _submit() {
    context.read<ContactUsCubit>().submit(
      message: _messageController.text.trim(),
      successMessage: context.localization.contactSubmitSuccess,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ContactUsCubit>().state;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.router.maybePop(),
          icon: SvgPicture.asset(Assets.icons.arrowNarrowLeft),
        ),
        title: Text(
          context.localization.writeToCarfy,
          style: TextStyle(color: context.theme.colors.black, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: BlocListener<ContactUsCubit, ContactUsState>(
        listenWhen: (prev, curr) => prev.submitStatus != curr.submitStatus,
        listener: (context, s) {
          showStateStatusToast(context, s.submitStatus);
          if (s.submitStatus is StateStatusSuccessWithMessage) {
            _messageController.clear();
            context.router.maybePop(true);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 2, offset: Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.user == null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        context.localization.contactLoginRequired,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.theme.colors.textLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  )
                else ...[
                  Text(
                    state.user!.fullName,
                    style: TextStyle(
                      color: context.theme.colors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.user!.email,
                    style: TextStyle(
                      color: context.theme.colors.textLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFE0E7F8), height: 1),
                  const SizedBox(height: 16),
                ],

                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: state.messageValidationState is FieldValidationFailure
                          ? context.theme.colors.error
                          : const Color(0xFFE0E7F8),
                    ),
                  ),
                  child: TextField(
                    controller: _messageController,
                    enabled: state.user != null,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                    style: TextStyle(
                      color: context.theme.colors.textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    decoration: InputDecoration(
                      hintText: context.localization.contactMessageHint,
                      hintStyle: const TextStyle(
                        color: Color(0xFF83847E),
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                if (state.messageValidationState is FieldValidationFailure) ...[
                  const SizedBox(height: 4),
                  Text(
                    state.messageValidationState.message!,
                    style: TextStyle(
                      color: context.theme.colors.error,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
                const SizedBox(height: 20),

                BlocBuilder<ContactUsCubit, ContactUsState>(
                  builder: (context, s) {
                    final loading = s.submitStatus is StateStatusLoading;
                    return CustomButton(
                      onPressed: (_canSubmit(s) && !loading) ? _submit : null,
                      text: context.localization.send,
                      height: 48,
                      loading: loading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
