import 'package:bybullet/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/task_input_controller.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

class DateSelectorDialogWidget extends StatelessWidget {
  final TaskInputController taskInputController =
      Get.find<TaskInputController>();

  @override
  Widget build(BuildContext context) {
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

                      // All day Toggle
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

                      // Time Display & Picker
                      Obx(() {
                        if (!taskInputController.isAllDay.value) {
                          return TimePickerSpinner(
                            is24HourMode: true,
                            normalTextStyle: TextStyle(fontSize: 16, color: Colors.grey),
                            highlightedTextStyle: TextStyle(fontSize: 20, color: Colors.black),
                            spacing: 50,
                            itemHeight: 40,
                            isForce2Digits: true,
                            onTimeChange: (time) {
                              taskInputController.selectTime(TimeOfDay.fromDateTime(time));
                            },
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }),

                      // Confirm
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

  Widget _buildTimeSelector(TaskInputController taskInputController) {
    return Obx(() => GestureDetector());
  }
}
