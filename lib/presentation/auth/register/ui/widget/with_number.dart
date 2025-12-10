part of '../page/register_page.dart';

class _RegisterWithNumber extends StatelessWidget {
  const _RegisterWithNumber();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
      child: SingleChildScrollView(
        child: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            showStateStatusToast(context, state.phoneRegisterState);
          },
          listenWhen: (oldState, newState) => oldState.phoneRegisterState != newState.phoneRegisterState,
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                context.localization.signUp,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.theme.colors.primary),
              ),
              SizedBox(height: 32),
              BlocBuilder<RegisterCubit, RegisterState>(
                buildWhen: (oldState, newState) => oldState.phoneValidationState != newState.phoneValidationState,
                builder: (context, state) {
                  return CustomTextField(
                    controller: cubit.phoneController,
                    hint: context.localization.mobileNumber,
                    errorText: state.phoneValidationState.message,
                    inputFormatters: [InputFormatter.getPhoneNumberFormatter()],
                    keyboardType: TextInputType.number,
                  );
                },
              ),
              SizedBox(height: 16),
              BlocBuilder<RegisterCubit, RegisterState>(
                buildWhen: (oldState, newState) => oldState.phoneRegisterState != newState.phoneRegisterState,
                builder: (context, state) {
                  return CustomButton(
                    onPressed: () => cubit.registerWithNumber(),
                    loading: state.phoneRegisterState is StateStatusLoading,
                    text: context.localization.forward,
                  );
                },
              ),
              SizedBox(height: 16),
              _Common(),
            ],
          ),
        ),
      ),
    );
  }
}
