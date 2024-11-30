import 'package:bybullet/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/task_input_controller.dart';

class DateSelectorDialogWidget extends StatelessWidget {
  final TaskInputController taskInputController =
      Get.find<TaskInputController>();

  @override
  Widget build(BuildContext context) {
    // return Dialog(
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //   child: Container(
    //     padding: EdgeInsets.all(20),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         // Table Calendar
    //         TableCalendar(
    //           focusedDay: taskInputController.selectedDate.value,
    //           firstDay: DateTime(2000),
    //           lastDay: DateTime(2100),
    //           selectedDayPredicate: (day) {
    //             return isSameDay(day, taskInputController.selectedDate.value);
    //           },
    //           onDaySelected: (selectedDay, focusedDay) {
    //             taskInputController.selectDate(selectedDay);
    //           },
    //           calendarStyle: CalendarStyle(
    //             selectedDecoration: BoxDecoration(
    //               color: AppColors.black,
    //               shape: BoxShape.circle,
    //             ),
    //             todayDecoration: BoxDecoration(
    //               color: AppColors.mediumGray,
    //               shape: BoxShape.circle,
    //             ),
    //           ),
    //           headerStyle: HeaderStyle(
    //             formatButtonVisible: true,
    //             titleCentered: true,
    //           ),
    //         ),
    //         SizedBox(height: 15),
    //
    //         // Time Selector
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Text("All Day"),
    //             Obx(
    //               () => Switch(
    //                   value: taskInputController.isAllDay.value,
    //                   onChanged: (value) {
    //                     taskInputController.toggleAllDay(value);
    //                   })),
    //             SizedBox(height: 16,),
    //             ElevatedButton(
    //                 onPressed: () {
    //                   Navigator.pop(context);
    //                 },
    //                 child: SvgPicture.asset(
    //                   'lib/assets/icons/check_icon.svg',
    //                   color: AppColors.black,
    //                   width: 7,
    //                 )
    //             )
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );

    return GestureDetector(
        onTap: () => {taskInputController.isDialogVisible.value = false},
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Table Calendar
                      Obx(() => TableCalendar(
                            focusedDay: taskInputController.selectedDate.value,
                            firstDay: DateTime(2000),
                            lastDay: DateTime(2100),
                            selectedDayPredicate: (day) {
                              return isSameDay(
                                  day, taskInputController.selectedDate.value);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              taskInputController.selectDate(selectedDay);
                            },
                            calendarStyle: CalendarStyle(
                              selectedDecoration: BoxDecoration(
                                color: AppColors.black,
                                shape: BoxShape.circle,
                              ),
                              todayDecoration: BoxDecoration(
                                color: AppColors.mediumGray,
                                shape: BoxShape.circle,
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                            ),
                          )),
                      SizedBox(height: 15),

                      // Time Selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("All Day"),
                          Obx(
                            () => Switch(
                              value: taskInputController.isAllDay.value,
                              onChanged: (value) {
                                taskInputController.toggleAllDay(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      GestureDetector(
                        onTap: () =>
                            {taskInputController.isDialogVisible.value = false},
                        child: SvgPicture.asset(
                          'lib/assets/icons/check_icon.svg',
                          color: AppColors.black,
                          width: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
