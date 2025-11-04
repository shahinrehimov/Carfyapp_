import 'package:auto_route/annotations.dart';
import 'package:carfy/common/util/custom_button.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(controller: TextEditingController(), hint: 'Elektron poçt'),
            SizedBox(height: 12),
            CustomButton(onPressed: () {}, width: double.maxFinite, text: 'Login'),
          ],
        ),
      ),
    );
  }
}
