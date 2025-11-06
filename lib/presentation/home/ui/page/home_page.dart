import 'package:auto_route/annotations.dart';
import 'package:carfy/common/widgets/not_logged_view.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: NotLoggedView(page: NotLoggedPage.profile)),
    );
  }
}
