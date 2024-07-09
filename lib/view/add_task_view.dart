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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Add task'),
        backgroundColor: myGreen,
      ),
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          SizedBox(height: screenHeight/6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: screenWidth / 5,
                child: ElevatedButton(
                  onPressed: () {
                    Task task = Task('Watering', 0);
                    viewModel.addItemToQueue(task, robot);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: myGreen),
                  child: const Text('Watering'),
                ),
              ),
              Container(
                width: screenWidth / 5,
                child: ElevatedButton(
                  onPressed: () {
                    Task task = Task('Planting', 0);
                    viewModel.addItemToQueue(task, robot);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: myGreen),
                  child: const Text("Planting"),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight/6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: screenWidth / 5,
                child: ElevatedButton(
                  onPressed: () {
                    Task task = Task('Harvesting', 0);
                    viewModel.addItemToQueue(task, robot);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: myGreen),
                  child: const Text('Harvesting'),
                ),
              ),
              Container(
                width: screenWidth / 5,
                child: ElevatedButton(
                  onPressed: () {
                    Task task = Task('PesticideAdding', 0);
                    viewModel.addItemToQueue(task, robot);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: myGreen),
                  child: const Text("PesticideAdding"),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight / 10),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.blue),
            onPressed: () {
              Navigator.pop(context, taskManager);
            },
          ),
        ],
      ),
    );
  }
}
