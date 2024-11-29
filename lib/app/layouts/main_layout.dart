import 'package:flutter/material.dart';
import '../../app/features/main/widgets/nav_bar.dart';
import '../../app/features/main/widgets/daily_app_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  MainLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DailyAppBar(),
      body: child,
      bottomNavigationBar: NavBar(),
    );
  }
}
