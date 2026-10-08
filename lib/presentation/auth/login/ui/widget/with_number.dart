part of '../page/login_page.dart';

class _LoginWithNumber extends StatelessWidget {
  const _LoginWithNumber();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
      child: SingleChildScrollView(
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            showStateStatusToast(context, state.phoneLoginState);
          },
          listenWhen: (oldState, newState) =>
              oldState.phoneLoginState != newState.phoneLoginState &&
              !(oldState.phoneLoginState is StateStatusBlockedFailure &&
                  newState.phoneLoginState is StateStatusBlockedFailure),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                context.localization.entranceToAccount,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.theme.colors.primary),
              ),
              const SizedBox(height: 32),
              BlocBuilder<LoginCubit, LoginState>(
                buildWhen: (oldState, newState) => oldState.phoneValidationState != newState.phoneValidationState,
                builder: (context, state) {
                  return CustomPhoneField(
                    controller: cubit.phoneController,
                    errorText: state.phoneValidationState.message,
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<LoginCubit, LoginState>(
                buildWhen: (oldState, newState) => oldState.phoneLoginState != newState.phoneLoginState,
                builder: (context, state) {
                  final blocked = state.phoneLoginState is StateStatusBlockedFailure
                    ? state.phoneLoginState as StateStatusBlockedFailure
                    : null;
                return CustomButton(
                    onPressed: state.phoneLoginState is StateStatusLoading || blocked != null
                        ? null
                        : () => cubit.loginWithNumber(),
                    loading: state.phoneLoginState is StateStatusLoading,
                    text: blocked != null
                        ? '${context.localization.forward} (${blocked.seconds}s)'
                        : context.localization.forward,
                  );
                },
              ),
              const SizedBox(height: 16),
              const _Common(),
            ],
          ),
        ),
      ),
    );
  }
}
