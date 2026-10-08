part of '../page/login_page.dart';

class _LoginWithEmail extends StatelessWidget {
  const _LoginWithEmail();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
      child: SingleChildScrollView(
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            showStateStatusToast(context, state.emailLoginState);
          },
          listenWhen: (oldState, newState) =>
              oldState.emailLoginState != newState.emailLoginState &&
              !(oldState.emailLoginState is StateStatusBlockedFailure &&
                  newState.emailLoginState is StateStatusBlockedFailure),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                context.localization.entranceToAccount,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.theme.colors.primary),
              ),
              const SizedBox(height: 32),
              BlocBuilder<LoginCubit, LoginState>(
                buildWhen: (oldState, newState) => oldState.emailValidationState != newState.emailValidationState,
                builder: (context, state) {
                  return CustomTextField(
                    controller: cubit.emailController,
                    hint: context.localization.email,
                    errorText: state.emailValidationState.message,
                    inputFormatters: [InputFormatter.getEmailFormatter()],
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<LoginCubit, LoginState>(
                buildWhen: (oldState, newState) =>
                    oldState.obscurePassword != newState.obscurePassword ||
                    oldState.passwordValidationState != newState.passwordValidationState,
                builder: (context, state) {
                  return CustomTextField(
                    controller: cubit.passwordController,
                    hint: context.localization.password,
                    inputFormatters: [InputFormatter.getPasswordFormatter()],
                    obscureText: state.obscurePassword,
                    maxLines: 1,
                    errorText: state.passwordValidationState.message,
                    suffix: GestureDetector(
                      onTap: () => cubit.toggleObscureText(),
                      child: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.eyeOff, width: 24, height: 24)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<LoginCubit, LoginState>(
                buildWhen: (oldState, newState) => oldState.emailLoginState != newState.emailLoginState,
                builder: (context, state) {
                  final blocked = state.emailLoginState is StateStatusBlockedFailure
                    ? state.emailLoginState as StateStatusBlockedFailure
                    : null;
                return CustomButton(
                    onPressed: state.emailLoginState is StateStatusLoading || blocked != null
                        ? null
                        : () => cubit.loginWithEmail(),
                    loading: state.emailLoginState is StateStatusLoading,
                    text: blocked != null
                        ? '${context.localization.forward} (${blocked.seconds}s)'
                        : context.localization.forward,
                  );
                },
              ),
              TextButton(
                onPressed: () => context.router.push(const ForgotPasswordRoute()),
                child: Text(
                  context.localization.forgotPassword,
                  style: TextStyle(color: context.theme.colors.primary, decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 10),
              const _Common(),
            ],
          ),
        ),
      ),
    );
  }
}
