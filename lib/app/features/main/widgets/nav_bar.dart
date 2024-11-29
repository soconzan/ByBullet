import 'package:bybullet/app/features/main/widgets/task_input.dart';
import 'package:bybullet/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/nav_bar_controller.dart';

class NavBar extends StatelessWidget {
  final NavBarController navBarController = Get.find<NavBarController>();

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   padding: EdgeInsets.all(10.0),
    //   decoration: BoxDecoration(
    //     color: AppColors.white
    //   ),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //     children: [
    //       _buildNavItem('day', 0),
    //       _buildNavItem('week', 1),
    //       _buildAddTaskButton(),
    //       _buildNavItem('month', 2),
    //       _buildNavItem('memo', 3),
    //     ],
    //   ),
    // );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() {
          if (navBarController.isTaskInputVisible.value) {
            // return TaskInputWidget(onClose: () {
            //   navBarController.isTaskInputVisible.value = false;
            // });
          }
          // return SizedBox.shrink();
          return TaskInputWidget();
        }),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
          decoration: BoxDecoration(color: AppColors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem('day', 0),
              _buildNavItem('week', 1),
              _buildAddTaskButton(),
              _buildNavItem('month', 2),
              _buildNavItem('memo', 3),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildNavItem(String label, int index) {
    return GestureDetector(
      onTap: () {
        navBarController.selectedIndex.value = index;
      },
      child: Obx(() => Container(
            width: 50.0,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: navBarController.selectedIndex.value == index
                      ? AppColors.black
                      : AppColors.mediumGray,
                ),
              ),
            ),
          )),
    );
  }

  Widget _buildAddTaskButton() {
    return GestureDetector(
      onTap: () {
        print("Add task Button clicked");
        navBarController.isTaskInputVisible.value = true;
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(45),
        child: Container(
          width: 50,
          height: 45,
          color: AppColors.black,
          child: Center(
            child: SvgPicture.asset(
              'lib/assets/icons/write_icon.svg',
              color: AppColors.white,
              width: 25,
            ),
          ),
        ),
      ),
    );
  }
}
