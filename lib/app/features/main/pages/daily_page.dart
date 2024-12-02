import 'package:bybullet/app/features/main/widgets/weekly_calendar_with_tasks.dart';
import 'package:bybullet/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../services/firestore_service.dart';
import '../controllers/daily_controller.dart';

class DailyPage extends StatelessWidget {
  final DailyController dailyController = Get.find<DailyController>();

  @override
  Widget build(BuildContext context) {
    dailyController.fetchTasks();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      // Swipe
      onHorizontalDragEnd: (details) {
        // right >>
        if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
          dailyController.changeDate(-1);
        }
        // left <<
        else if (details.primaryVelocity != null &&
            details.primaryVelocity! < 0) {
          dailyController.changeDate(1);
        }
      },

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // mini dialog
            WeeklyCalendarWithTasks(),
            SizedBox(
              height: 20,
            ),

            // task list
            Obx(() {
              if (dailyController.tasks.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 50), // 원하는 패딩 값 지정
                    child: Text(
                      "No tasks!",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                );
              }

              return _buildTaskList();
            }),
          ],
        ),
      ),
    );
  }

  // Widget _buildTaskList() {
  //   return Expanded(
  //     child: Obx(() {
  //       final tasks = dailyController.tasks;
  //       return ListView.builder(
  //         itemCount: tasks.length,
  //         itemBuilder: (context, index) {
  //           final task = tasks[index];
  //           final bulletIcon = "lib/assets/icons/${task.bullet}_bullet.svg";
  //
  //           return GestureDetector(
  //             onTap: task.bullet == "task" || task.bullet == "completed"
  //                 ? () => dailyController.toggleTaskBullet(task.id, task.bullet)
  //                 : null,
  //             child: Container(
  //               padding: EdgeInsets.symmetric(vertical: 8),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   // Bullet icon
  //                   SvgPicture.asset(
  //                     bulletIcon,
  //                     color: task.isCanceled ? AppColors.mediumGray : AppColors.black,
  //                     width: 12,
  //                   ),
  //                   SizedBox(width: 10),
  //
  //                   // Time
  //                   if (task.time != null)
  //                     Text(
  //                       task.time!,
  //                       style: TextStyle(
  //                         fontSize: 14,
  //                         color: task.isCanceled
  //                             ? AppColors.mediumGray
  //                             : AppColors.darkGray,
  //                       ),
  //                     ),
  //                   if (task.time != null) SizedBox(width: 5),
  //
  //                   // Task text
  //                   Expanded(
  //                     child: Text(
  //                       task.text,
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                         color: task.isCanceled ? AppColors.mediumGray : AppColors.black,
  //                         decoration: task.isCanceled ? TextDecoration.lineThrough : null,
  //                         decorationColor: AppColors.mediumGray,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     }),
  //   );
  // }

  Widget _buildTaskList() {
    return Expanded(
      child: Obx(() {
        final tasks = dailyController.tasks;

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            // final isSwiped = dailyController.swipedIndex.value == index;
            // final bulletIcon = isSwiped
            //     ? "lib/assets/icons/migrated_bullet.svg"
            //     : "lib/assets/icons/${task.bullet}_bullet.svg";

            return Dismissible(
              key: ValueKey(task.id),
              direction: DismissDirection.horizontal,
              background: Container(
                color: AppColors.lightGray,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.chevron_right, color: AppColors.black),
              ),
              secondaryBackground: Container(
                color: AppColors.mediumGray,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.chevron_left, color: AppColors.white),
              ),
              onUpdate: (details) {
                if (details.reached) {
                  dailyController.setSwipedIndex(index);
                }
              },
              onDismissed: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  await dailyController.toggleTaskCanceled(task.id);
                } else if (direction == DismissDirection.startToEnd) {
                  await dailyController.migrateTask(task.id, task.date);
                }
                dailyController.resetSwipedIndex();
              },
              child: GestureDetector(
                onTap: task.bullet == "task" || task.bullet == "completed"
                    ? () =>
                        dailyController.toggleTaskBullet(task.id, task.bullet)
                    : null,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Bullet icon
                      SvgPicture.asset(
                        "lib/assets/icons/${task.bullet}_bullet.svg",
                        color: task.isCanceled
                            ? AppColors.mediumGray
                            : AppColors.black,
                        width: 12,
                      ),
                      SizedBox(width: 10),

                      // Time
                      if (task.time != null)
                        Text(
                          task.time!,
                          style: TextStyle(
                            fontSize: 14,
                            color: task.isCanceled
                                ? AppColors.mediumGray
                                : AppColors.darkGray,
                          ),
                        ),
                      if (task.time != null) SizedBox(width: 5),

                      // Task text
                      Expanded(
                        child: GestureDetector(
                          onLongPress: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Delete Task"),
                                content: Text("삭제하시겠습니까?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text("취소"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text("삭제"),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await dailyController.deleteTask(task.id);
                            }
                          },
                          child: Text(
                            task.text,
                            style: TextStyle(
                              fontSize: 16,
                              color: task.isCanceled
                                  ? AppColors.mediumGray
                                  : AppColors.black,
                              decoration: task.isCanceled
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: AppColors.mediumGray,
                            ),
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: Text(
                      //     task.text,
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: task.isCanceled
                      //           ? AppColors.mediumGray
                      //           : AppColors.black,
                      //       decoration: task.isCanceled
                      //           ? TextDecoration.lineThrough
                      //           : null,
                      //       decorationColor: AppColors.mediumGray,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

// Widget _buildTaskList() {
//   return Expanded(
//     child: Obx(() {
//       final tasks = dailyController.tasks;
//
//       return ListView.builder(
//         itemCount: tasks.length,
//         itemBuilder: (context, index) {
//           final task = tasks[index];
//           final isSwiped = dailyController.swipedIndex.value == index;
//
//           final bulletIcon = isSwiped && dailyController.isRightSwipe.value
//               ? "lib/assets/icons/migrated_bullet.svg"
//               : "lib/assets/icons/${task.bullet}_bullet.svg";
//
//           return Stack(
//             children: [
//               Dismissible(
//                 key: ValueKey(task.id),
//                 direction: DismissDirection.startToEnd,
//                 background: Container(
//                   decoration: BoxDecoration(
//                     color: AppColors.lightGray,
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(50),
//                       bottomRight: Radius.circular(50),
//                     ),
//                   ),
//                   alignment: Alignment.centerRight,
//                   padding: EdgeInsets.symmetric(horizontal: 20),
//                   child: Icon(Icons.chevron_right, color: AppColors.darkGray),
//                 ),
//                 onDismissed: (direction) async {
//                   if (direction == DismissDirection.startToEnd) {
//                     await dailyController.migrateTask(task.id, task.date);
//                   }
//                   dailyController.resetSwipedIndex();
//                 },
//                 child: Container(
//                   color: Colors.transparent,
//                   child: GestureDetector(
//                     onHorizontalDragUpdate: (details) {
//                       if (details.primaryDelta! < 0) {
//                         dailyController.setSwipedIndex(index, false);
//                       }
//                     },
//                     onHorizontalDragEnd: (details) {
//                       if (dailyController.swipedIndex.value == index &&
//                           !dailyController.isRightSwipe.value) {
//                         dailyController.toggleTaskCanceled(task.id);
//                         dailyController.resetSwipedIndex();
//                       }
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(vertical: 8),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           // Bullet Icon
//                           SvgPicture.asset(
//                             bulletIcon,
//                             color: task.isCanceled
//                                 ? AppColors.mediumGray
//                                 : AppColors.black,
//                             width: 12,
//                           ),
//                           SizedBox(width: 10),
//
//                           // Time
//                           if (task.time != null)
//                             Text(
//                               task.time!,
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: task.isCanceled
//                                     ? AppColors.mediumGray
//                                     : AppColors.darkGray,
//                               ),
//                             ),
//                           if (task.time != null) SizedBox(width: 5),
//
//                           // Task Text
//                           Expanded(
//                             child: GestureDetector(
//                               onLongPress: () async {
//                                 final confirm = await showDialog<bool>(
//                                   context: context,
//                                   builder: (context) => AlertDialog(
//                                     title: Text("Delete Task"),
//                                     content: Text("삭제하시겠습니까?"),
//                                     actions: [
//                                       TextButton(
//                                         onPressed: () => Navigator.of(context).pop(false),
//                                         child: Text("취소"),
//                                       ),
//                                       TextButton(
//                                         onPressed: () => Navigator.of(context).pop(true),
//                                         child: Text("삭제"),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//
//                                 if (confirm == true) {
//                                   await dailyController.deleteTask(task.id);
//                                 }
//                               },
//                               child: Text(
//                                 task.text,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: task.isCanceled ? AppColors.mediumGray : AppColors.black,
//                                   decoration: task.isCanceled ? TextDecoration.lineThrough : null,
//                                   decorationColor: AppColors.mediumGray,
//                                 ),
//                               ),
//                             ),
//                           ),
//
//                           // Expanded(
//                           //   child: Text(
//                           //     task.text,
//                           //     style: TextStyle(
//                           //       fontSize: 16,
//                           //       color: task.isCanceled
//                           //           ? AppColors.mediumGray
//                           //           : AppColors.black,
//                           //       decoration: task.isCanceled
//                           //           ? TextDecoration.lineThrough
//                           //           : null,
//                           //       decorationColor: AppColors.mediumGray,
//                           //     ),
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     }),
//   );
// }
}
