import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class BasketPage extends StatelessWidget {
  const BasketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text('basket')),
    );
  }
}
