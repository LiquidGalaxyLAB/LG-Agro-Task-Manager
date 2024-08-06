import 'package:flutter/material.dart';
import 'package:taskmanager/model/task_manager.dart';
import 'package:taskmanager/view_models/add_task_view_model.dart';

import '../model/robot.dart';
import '../model/task.dart';

class AddTaskView extends StatelessWidget {
  final TaskManager taskManager;
  final Robot robot;
  final AddTaskViewModel viewModel = AddTaskViewModel();

  AddTaskView({super.key, required this.taskManager, required this.robot});

  final Color myGreen = const Color(0xFF3E9671);
  final Color customDarkGrey = const Color(0xFF333333);
  final Color customLightGrey = const Color(0xFF4F4F4F);
  final Color customWhite = const Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Add Task'),
        backgroundColor: myGreen,
      ),
      backgroundColor: customDarkGrey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight / 10),
          Text(
            'Choose a Task for ${robot.name}',
            style: TextStyle(
              color: customWhite,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight / 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTaskButton(context, 'Watering', Icons.water_drop),
              _buildTaskButton(context, 'Planting', Icons.local_florist),
            ],
          ),
          SizedBox(height: screenHeight / 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTaskButton(context, 'Harvesting', Icons.agriculture),
              _buildTaskButton(context, 'PesticideAdding', Icons.bug_report),
            ],
          ),
          SizedBox(height: screenHeight / 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, taskManager);
            },
            style: ElevatedButton.styleFrom(backgroundColor: myGreen),
            child: const Text(
              'Confirm',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTaskButton(
      BuildContext context, String taskName, IconData icon) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth / 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          Task task = Task(taskName, 0);
          viewModel.addItemToQueue(task, robot);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: myGreen,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: Icon(icon, color: customWhite),
        label: Text(
          taskName,
          style: TextStyle(color: customWhite, fontSize: 16),
        ),
      ),
    );
  }
}
