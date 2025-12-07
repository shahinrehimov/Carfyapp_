part of '../page/login_page.dart';

class _Common extends StatelessWidget {
  const _Common();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider()),
            SizedBox(width: 10),
            Text(Languages.of(context)!.or, style: TextStyle(color: context.theme.colors.textDark)),
            SizedBox(width: 10),
            Expanded(child: Divider()),
          ],
        ),
        SizedBox(height: 16),
        CustomButton(
          onPressed: () {},
          text: Languages.of(context)!.google,
          backgroundColor: Colors.transparent,
          outlineColor: context.theme.colors.secondary,
          color: Color(0xFF0E1217),
          fontWeight: FontWeight.w700,
          fontSize: 18,
          prefix: SvgPicture.asset(Assets.icons.googleIconLogo),
        ),
        SizedBox(height: 16),
        CustomButton(
          onPressed: () {},
          text: Languages.of(context)!.google,
          backgroundColor: Colors.transparent,
          outlineColor: context.theme.colors.secondary,
          color: Color(0xFF0E1217),
          fontWeight: FontWeight.w700,
          fontSize: 18,
          prefix: SvgPicture.asset(Assets.icons.appleIconLogo),
        ),
        SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Languages.of(context)!.doNotHaveAccount,
              style: TextStyle(color: context.theme.colors.textBlack, fontSize: 12, fontWeight: FontWeight.w300),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                Languages.of(context)!.signUp,
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
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            Languages.of(context)!.signUpTermsText,
            style: TextStyle(fontSize: 8, color: context.theme.colors.textDark),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
