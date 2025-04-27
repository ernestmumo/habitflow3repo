import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/profile_controller.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              // Ensure content is scrollable on small screens
              minHeight: deviceHeight - MediaQuery.of(context).padding.vertical,
              maxWidth: deviceWidth,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildProfileHeader(deviceHeight, deviceWidth),
                _buildStatsSection(deviceHeight, deviceWidth, context),
                _buildAchievements(deviceHeight, deviceWidth, context),
                _buildActivityFeed(deviceHeight, deviceWidth,context),
                _buildSettings(deviceHeight, deviceWidth, context),
                // Add bottom padding to ensure we don't overflow
                SizedBox(height: deviceHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(double deviceHeight, double deviceWidth) {
    return Obx(() => Container(
          height: deviceHeight * 0.30,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Banner design elements
              Positioned(
                top: -50,
                right: -20,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Profile content
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile picture
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        image: controller.profileImageUrl.value.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(controller.profileImageUrl.value),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: Colors.white,
                      ),
                      child: controller.profileImageUrl.value.isEmpty
                          ? Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.blue.shade200,
                            )
                          : null,
                    ),
                    SizedBox(height: 12),
                    // Name
                    Text(
                      controller.name.value,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    // Bio
                    Text(
                      controller.bio.value,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Edit button
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    _showEditProfileDialog(Get.context!);
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildStatsSection(double deviceHeight, double deviceWidth,BuildContext context) {
    return Obx(() => Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Stats',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(context,
                      icon: Icons.checklist,
                      iconColor: Colors.blue.shade600,
                      value: controller.totalHabits.value.toString(),
                      label: 'Total Habits',
                    ),
                    _buildStatItem(context,
                      icon: Icons.local_fire_department,
                      iconColor: Colors.orange,
                      value: controller.currentStreak.value.toString(),
                      label: 'Current Streak',
                    ),
                    _buildStatItem(context,
                      icon: Icons.emoji_events,
                      iconColor: Colors.amber,
                      value: controller.longestStreak.value.toString(),
                      label: 'Longest Streak',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Weekly progress card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Weekly Activity',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${controller.weeklyCompletionRate.value.toStringAsFixed(0)}% Done',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 150,
                      child: _buildActivityChart(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildActivityChart(BuildContext context) {
    final weekData = controller.getWeeklyActivityData();
    final weekDayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return BarChart(
      BarChartData(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        alignment: BarChartAlignment.spaceAround,
        maxY: 10,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueAccent,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${weekData[groupIndex]['count']} activities',
                TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    weekDayLabels[value.toInt() % weekDayLabels.length],
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value % 2 != 0) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '${value.toInt()}',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          getDrawingHorizontalLine: (value) {
            if (value % 2 != 0) return FlLine(color: Colors.transparent);
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
              dashArray: [5],
            );
          },
          drawVerticalLine: false,
        ),
        barGroups: List.generate(weekData.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: (weekData[index]['count'] as int).toDouble(),
                color: Colors.blue.shade400,
                width: 20,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context,{
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievements(double deviceHeight, double deviceWidth,BuildContext context) {
    return Obx(() => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Achievements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Show all achievements
                    },
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                height: 130,
                child: controller.achievements.isEmpty
                    ? Center(
                        child: Text(
                          'No achievements yet',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.achievements.length,
                        itemBuilder: (context, index) {
                          final achievement = controller.achievements[index];
                          return Container(
                            width: 120,
                            margin: EdgeInsets.only(right: 12),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  achievement.icon,
                                  size: 40,
                                  color: Colors.amber,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  achievement.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  DateFormat.yMMMd().format(achievement.earnedAt),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ));
  }

  Widget _buildActivityFeed(double deviceHeight, double deviceWidth,BuildContext context) {
    return Obx(() => Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 16),
              controller.activityLogs.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No recent activity',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.activityLogs.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          indent: 70,
                        ),
                        itemBuilder: (context, index) {
                          final activity = controller.activityLogs[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Icon(
                                activity.icon,
                                size: 20,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            title: Text(
                              activity.description,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              _getTimeAgo(activity.timestamp),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ));
  }

  Widget _buildSettings(double deviceHeight, double deviceWidth, BuildContext context) {
    return Obx(() => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      icon: Icons.dark_mode,
                      title: 'Dark Mode',
                      trailing: Switch(
                        value: controller.darkMode.value,
                        onChanged: (value) {
                          controller.toggleDarkMode();
                        },
                        activeColor: Colors.blue.shade600,
                      ),
                    ),
                    Divider(height: 1),
                    _buildSettingsItem(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      trailing: Switch(
                        value: controller.notificationsEnabled.value,
                        onChanged: (value) {
                          controller.toggleNotifications();
                        },
                        activeColor: Colors.blue.shade600,
                      ),
                    ),
                    Divider(height: 1),
                    _buildSettingsItem(
                      icon: Icons.access_time,
                      title: 'Reminder Time',
                      subtitle: controller.reminderTime.value,
                      onTap: () {
                        // Show time picker dialog
                      },
                    ),
                    Divider(height: 1),
                    _buildSettingsItem(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: () {
                        // Navigate to help page
                      },
                    ),
                    Divider(height: 1),
                    _buildSettingsItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      titleColor: Colors.red,
                      onTap: () {
                        controller.logout();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color? titleColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: titleColor ?? Colors.blue.shade600,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                )
              : null),
      onTap: onTap,
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: controller.name.value);
    final bioController = TextEditingController(text: controller.bio.value);

    Get.dialog(
      AlertDialog(
        title: Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue.shade50,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.blue.shade200,
                ),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  // Add image picker functionality here
                },
                child: Text('Change Photo'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: bioController,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateProfile(
                name: nameController.text,
                bio: bioController.text,
              );
              Get.back();
            },
            child: Text('Save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
