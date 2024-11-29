import 'package:flutter/material.dart';
import '../../app/features/main/widgets/nav_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  MainLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavBar(),
    );
  }
}
