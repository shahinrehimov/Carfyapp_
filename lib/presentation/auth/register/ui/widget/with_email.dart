part of '../page/register_page.dart';

class _RegisterWithEmail extends StatelessWidget {
  const _RegisterWithEmail();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
      child: SingleChildScrollView(
        child: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            showStateStatusToast(context, state.checkEmailState);
          },
          listenWhen: (oldState, newState) => oldState.checkEmailState != newState.checkEmailState,
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                context.localization.signUp,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.theme.colors.primary),
              ),
              SizedBox(height: 32),
              BlocBuilder<RegisterCubit, RegisterState>(
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
              SizedBox(height: 16),
              BlocBuilder<RegisterCubit, RegisterState>(
                buildWhen: (oldState, newState) => oldState.checkEmailState != newState.checkEmailState,
                builder: (context, state) {
                  return CustomButton(
                    onPressed: () => cubit.checkEmail(),
                    loading: state.checkEmailState is StateStatusLoading,
                    text: context.localization.forward,
                  );
                },
              ),
              TextButton(
                onPressed: () => context.router.push(ForgotPasswordRoute()),
                child: Text(
                  context.localization.forgotPassword,
                  style: TextStyle(color: context.theme.colors.primary, decoration: TextDecoration.underline),
                ),
              ),
              SizedBox(height: 10),
              _Common(),
            ],
          ),
        ),
      ),
    );
  }
}
