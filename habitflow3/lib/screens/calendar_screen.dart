import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../controllers/calendar_controller.dart' as app_calendar;

class CalendarScreen extends StatelessWidget {
  final app_calendar.CalendarController controller = Get.put(
    app_calendar.CalendarController(),
  );

  CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(deviceHeight),
            Expanded(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        deviceHeight - 100, // Account for header and safe area
                    maxWidth: deviceWidth,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildCalendar(deviceHeight, deviceWidth),
                      _buildMonthlyOverview(deviceHeight, deviceWidth),
                      _buildSelectedDayDetails(deviceHeight, deviceWidth),
                      // Add some bottom padding
                      SizedBox(height: deviceHeight * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double deviceHeight) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Habit Calendar',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              IconButton(
                icon: Icon(Icons.today, color: Colors.blue.shade600),
                onPressed: () {
                  // Reset to today
                  controller.onDaySelected(DateTime.now(), DateTime.now());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(double deviceHeight, double deviceWidth) {
    return Obx(
      () => Card(
        margin: EdgeInsets.all(16),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: controller.focusedDay.value,
            calendarFormat: controller.calendarFormat.value,
            selectedDayPredicate: (day) {
              return isSameDay(controller.selectedDay.value, day);
            },
            onDaySelected: controller.onDaySelected,
            onFormatChanged: controller.onFormatChanged,
            onPageChanged: controller.onPageChanged,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              markersMaxCount: 3,
              markerDecoration: BoxDecoration(
                color: Colors.blue.shade600,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue.shade600,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.blue.shade200,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonDecoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: BorderRadius.circular(16),
              ),
              formatButtonTextStyle: TextStyle(color: Colors.white),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final dayStats = controller.getDayStatistics(date);
                final completionRate = dayStats['completionRate'] as double;

                if (completionRate <= 0) {
                  return null;
                }

                // Return a colored circle indicator based on completion rate
                return Positioned(
                  bottom: 1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          completionRate >= 80
                              ? Colors.green
                              : completionRate >= 50
                              ? Colors.amber
                              : Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyOverview(double deviceHeight, double deviceWidth) {
    return Obx(
      () => Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.insert_chart, color: Colors.blue.shade600),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.selectedMonthOverview.value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: controller.monthlyCompletionRate.value / 100,
                    backgroundColor: Colors.white,
                    color: Colors.blue.shade600,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDayDetails(double deviceHeight, double deviceWidth) {
    return Obx(() {
      final selectedDay = DateFormat(
        'EEEE, MMMM d, y',
      ).format(controller.selectedDay.value);
      final records = controller.selectedDayRecords;

      if (records.isEmpty) {
        return Container(
          height: deviceHeight * 0.2, // Limit height of empty state
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 70,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'No habits tracked on',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 4),
                Text(
                  selectedDay,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final dayStats = controller.getDayStatistics(
        controller.selectedDay.value,
      );
      final completionRate = dayStats['completionRate'] as double;
      final completedHabits = dayStats['completedHabits'] as int;
      final totalHabits = dayStats['totalHabits'] as int;

      // No need for device dimensions as we're using Flexible widgets

      return Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Text(
                    selectedDay,
                    style: TextStyle(
                      fontSize: 15, // Slightly reduced font size
                      fontWeight: FontWeight.w500,
                      color: Colors.blue.shade800,
                    ),
                    overflow: TextOverflow.ellipsis, // Handle text overflow
                  ),
                ),
                SizedBox(width: 8), // Add spacing between elements
                Flexible(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ), // Reduced padding
                    decoration: BoxDecoration(
                      color: _getCompletionRateColor(
                        completionRate,
                      ).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '$completedHabits/$totalHabits completed', // Shortened text
                      style: TextStyle(
                        fontSize: 11, // Reduced font size
                        fontWeight: FontWeight.w500,
                        color: _getCompletionRateColor(completionRate),
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis, // Handle text overflow
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return Card(
                  elevation: 1,
                  margin: EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: record.categoryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.category, color: record.categoryColor),
                    ),
                    title: Text(
                      record.habitName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        decoration:
                            record.completed
                                ? TextDecoration.lineThrough
                                : null,
                        color: record.completed ? Colors.grey : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      record.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: record.categoryColor,
                      ),
                    ),
                    trailing:
                        record.completed
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : Icon(
                              Icons.radio_button_unchecked,
                              color: Colors.grey,
                            ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Color _getCompletionRateColor(double rate) {
    if (rate >= 80) return Colors.green;
    if (rate >= 50) return Colors.amber;
    return Colors.red;
  }
}
