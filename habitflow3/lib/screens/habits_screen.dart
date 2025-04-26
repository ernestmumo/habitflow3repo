import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../controllers/habits_controller.dart';
import '../models/habit_model.dart';
import '../models/habit_category.dart';

class HabitsScreen extends StatelessWidget {
  final HabitsController controller = Get.put(HabitsController());

  HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderAndSearch(deviceHeight, deviceWidth),
            _buildFilterOptions(deviceHeight, deviceWidth, context),
            Expanded(
              child: _buildHabitsList(deviceHeight, deviceWidth),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show dialog to add new habit
          _showAddHabitDialog(context);
        },
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeaderAndSearch(double deviceHeight, double deviceWidth) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Habits',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.sort, color: Colors.blue.shade600),
                onSelected: (value) {
                  controller.setSortType(value);
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'Default',
                    child: Row(
                      children: [
                        Icon(Icons.sort, size: 20, color: Colors.blue.shade600),
                        SizedBox(width: 8),
                        Text('Default (Pinned First)'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Name',
                    child: Row(
                      children: [
                        Icon(Icons.sort_by_alpha, size: 20, color: Colors.blue.shade600),
                        SizedBox(width: 8),
                        Text('By Name'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Newest',
                    child: Row(
                      children: [
                        Icon(Icons.date_range, size: 20, color: Colors.blue.shade600),
                        SizedBox(width: 8),
                        Text('Newest First'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Oldest',
                    child: Row(
                      children: [
                        Icon(Icons.date_range, size: 20, color: Colors.blue.shade600),
                        SizedBox(width: 8),
                        Text('Oldest First'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Streak',
                    child: Row(
                      children: [
                        Icon(Icons.local_fire_department, size: 20, color: Colors.blue.shade600),
                        SizedBox(width: 8),
                        Text('By Streak'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                controller.setSearchQuery(value);
              },
              decoration: InputDecoration(
                hintText: 'Search habits...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions(double deviceHeight, double deviceWidth,BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(top: 16),
      child: Obx(() => ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          // All filter
          _buildFilterChip(
            context,
            label: 'All',
            isSelected: controller.filterType.value == 'All',
            onTap: () => controller.setFilterType('All'),
            icon: Icons.all_inclusive,
          ),
          // Category filters
          ...controller.categories.map((category) => _buildFilterChip(
            context,
            label: category.name,
            isSelected: controller.filterType.value == category.name,
            onTap: () => controller.setFilterType(category.name),
            icon: category.icon,
            color: category.color,
          )),
        ],
      )),
    );
  }

  Widget _buildFilterChip(BuildContext context,{
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? (color ?? Colors.blue.shade600) : Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: (color ?? Colors.blue.shade600).withOpacity(0.3),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : color ?? Colors.blue.shade600,
            ),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitsList(double deviceHeight, double deviceWidth) {
    return Obx(() {
      if (controller.filteredHabits.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 70,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'No habits found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Add a new habit to get started',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  _showAddHabitDialog(Get.context!);
                },
                icon: Icon(Icons.add),
                label: Text('Add Habit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 80), // Extra bottom padding for FAB
        itemCount: controller.filteredHabits.length,
        itemBuilder: (context, index) {
          final habit = controller.filteredHabits[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      _showEditHabitDialog(context, habit);
                    },
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      Get.defaultDialog(
                        title: 'Delete Habit',
                        middleText: 'Are you sure you want to delete "${habit.name}"?',
                        textConfirm: 'Delete',
                        textCancel: 'Cancel',
                        confirmTextColor: Colors.white,
                        buttonColor: Colors.red,
                        cancelTextColor: Colors.black87,
                        onConfirm: () {
                          controller.deleteHabit(habit.id);
                          Get.back();
                        },
                      );
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: Obx(() => GestureDetector(
                onTap: () {
                  _showHabitDetails(context, habit);
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: habit.isPinned.value
                        ? BorderSide(color: Colors.blue.shade600, width: 2)
                        : BorderSide.none,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Category indicator
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: habit.category.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Icon(
                              habit.category.icon,
                              color: habit.category.color,
                              size: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        // Habit details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (habit.isPinned.value)
                                    Padding(
                                      padding: EdgeInsets.only(right: 6),
                                      child: Icon(
                                        Icons.push_pin,
                                        size: 16,
                                        color: Colors.blue.shade600,
                                      ),
                                    ),
                                  Expanded(
                                    child: Text(
                                      habit.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        decoration: habit.isDone.value
                                            ? TextDecoration.lineThrough
                                            : null,
                                        color: habit.isDone.value
                                            ? Colors.grey
                                            : Theme.of(Get.context!).colorScheme.onSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                habit.description,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  // Streak indicator
                                  Icon(
                                    Icons.local_fire_department,
                                    size: 16,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '${habit.streakCount} day streak',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  // Reminder indicator
                                  Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    habit.reminder,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Checkbox
                        Obx(() => Checkbox(
                          activeColor: Colors.blue.shade600,
                          value: habit.isDone.value,
                          onChanged: (value) {
                            controller.toggleHabitCompletion(habit.id);
                          },
                        )),
                      ],
                    ),
                  ),
                ),
              )),
            ),
          );
        },
      );
    });
  }

  void _showAddHabitDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    
    final selectedCategory = Rx<HabitCategory?>(controller.categories[0]);
    final selectedTime = Rx<TimeOfDay>(TimeOfDay.now());
    
    Get.dialog(
      AlertDialog(
        title: Text('Add New Habit'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Habit Name Field
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Habit Name',
                  hintText: 'Enter habit name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.edit, color: Colors.blue.shade400),
                ),
              ),
              SizedBox(height: 16),
              
              // Habit Description Field
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe your habit',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.description, color: Colors.blue.shade400),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 16),
              
              // Habit Category Selection
              Text(
                'Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Obx(() => Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return GestureDetector(
                      onTap: () {
                        selectedCategory.value = category;
                      },
                      child: Container(
                        width: 80,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: selectedCategory.value?.name == category.name
                              ? category.color.withOpacity(0.2)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selectedCategory.value?.name == category.name
                                ? category.color
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              category.icon,
                              color: category.color,
                              size: 28,
                            ),
                            SizedBox(height: 6),
                            Text(
                              category.name,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: selectedCategory.value?.name == category.name
                                    ? category.color
                                    : Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )),
              SizedBox(height: 16),
              
              // Reminder Time Selection
              Row(
                children: [
                  Text(
                    'Daily Reminder',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Obx(() => GestureDetector(
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime.value,
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Colors.blue.shade600,
                              colorScheme: ColorScheme.light(
                                primary: Colors.blue.shade600,
                              ),
                              buttonTheme: ButtonThemeData(
                                textTheme: ButtonTextTheme.primary,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        selectedTime.value = picked;
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.blue.shade600),
                          SizedBox(width: 6),
                          Text(
                            selectedTime.value.format(context),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
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
              // Validate inputs
              if (nameController.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please enter a habit name',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }
              
              // Create new habit
              final newHabit = HabitModel(
                id: 'habit_${DateTime.now().millisecondsSinceEpoch}',
                name: nameController.text,
                description: descriptionController.text.isEmpty ? 
                             'No description' : descriptionController.text,
                category: selectedCategory.value!,
                createdAt: DateTime.now(),
                streakCount: 0,
                longestStreak: 0,
                isPinned: false,
                isDone: false,
                completedDates: [],
                reminder: selectedTime.value.format(context),
              );
              
              // Add habit to controller
              controller.addHabit(newHabit);
              
              // Show success message
              Get.back();
              Get.snackbar(
                'Success',
                'Habit "${nameController.text}" added successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text('Add'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditHabitDialog(BuildContext context, HabitModel habit) {
    // This would be implemented with a form to edit an existing habit
    Get.dialog(
      AlertDialog(
        title: Text('Edit Habit'),
        content: SizedBox(
          width: double.maxFinite,
          child: Text('This would be a form to edit the habit.'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(),
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

  void _showHabitDetails(BuildContext context, HabitModel habit) {
    // This would show detailed information about the habit
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: habit.category.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(habit.category.icon, color: habit.category.color),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    habit.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Obx(() => Icon(
                    habit.isPinned.value ? Icons.push_pin : Icons.push_pin_outlined,
                    color: habit.isPinned.value ? Colors.blue.shade600 : Colors.grey,
                  )),
                  onPressed: () {
                    controller.togglePinned(habit.id);
                    Get.back();
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              habit.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  icon: Icons.local_fire_department,
                  iconColor: Colors.orange,
                  value: '${habit.streakCount}',
                  label: 'Current Streak',
                ),
                _buildStatColumn(
                  icon: Icons.emoji_events,
                  iconColor: Colors.amber,
                  value: '${habit.longestStreak}',
                  label: 'Longest Streak',
                ),
                _buildStatColumn(
                  icon: Icons.calendar_today,
                  iconColor: Colors.blue.shade600,
                  value: '${habit.completedDates.length}',
                  label: 'Total Check-ins',
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Edit function
                      Get.back();
                      _showEditHabitDialog(context, habit);
                    },
                    icon: Icon(Icons.edit),
                    label: Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade600,
                      side: BorderSide(color: Colors.blue.shade600),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.toggleHabitCompletion(habit.id);
                      Get.back();
                    },
                    icon: Icon(habit.isDone.value ? Icons.close : Icons.check),
                    label: Text(habit.isDone.value ? 'Unmark' : 'Complete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: habit.isDone.value ? Colors.red : Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 28),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
