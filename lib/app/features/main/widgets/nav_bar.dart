import 'package:bybullet/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/nav_bar_controller.dart';

class NavBar extends StatelessWidget {
  final NavBarController navBarController = Get.put(NavBarController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: AppColors.white
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem('Day', 0),
          _buildNavItem('Week', 1),
          _buildAddTaskButton(),
          _buildNavItem('Month', 2),
          _buildNavItem('Year', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, int index) {
    return GestureDetector(
      onTap: () {
        navBarController.selectedIndex.value = index;
      },
      child: Obx(() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
            style: TextStyle(
              color: navBarController.selectedIndex.value == index
                  ? AppColors.black
                  : AppColors.darkGray,
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildAddTaskButton() {
    return GestureDetector(
      onTap: () {
        print("Add task Button clicked");
      },
      child: CircleAvatar(
        radius: 30,
        backgroundColor: AppColors.black,
        child: SvgPicture.asset(
          'assets/icons/add_icon.svg',
          color: AppColors.white,
          width: 25,
          height: 25,
        ),
      ),
    );
  }

}