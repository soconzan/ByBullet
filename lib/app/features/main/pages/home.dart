import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../layouts/main_layout.dart';
import 'daily_page.dart';
import 'week_page.dart';
import 'month_page.dart';
import 'memo_page.dart';
import '../controllers/nav_bar_controller.dart';

class HomePage extends StatelessWidget {
  final NavBarController navBarController = Get.find<NavBarController>();

  final List<Widget> pages = [
    DailyPage(),
    WeekPage(),
    MonthPage(),
    MemoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => MainLayout(
          child: pages[navBarController.selectedIndex.value],
        ));
  }
}
