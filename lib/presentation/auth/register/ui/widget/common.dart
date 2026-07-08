part of '../page/register_page.dart';

class _Common extends StatelessWidget {
  const _Common();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            const SizedBox(width: 10),
            Text(context.localization.or, style: TextStyle(color: context.theme.colors.textDark)),
            const SizedBox(width: 10),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        const SocialLoginButtons(),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.localization.alreadyHaveAccount,
              style: TextStyle(color: context.theme.colors.textBlack, fontSize: 12, fontWeight: FontWeight.w300),
            ),
            TextButton(
              onPressed: () => context.router.maybePop(),
              child: Text(
                context.localization.login,
                style: TextStyle(
                  color: context.theme.colors.secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            context.localization.signUpTermsText,
            style: TextStyle(fontSize: 8, color: context.theme.colors.textDark),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
