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


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final oneFourthHeight = screenHeight / 4;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Add task'),
      ),
      body: Column(
        children: [
          SizedBox(height: oneFourthHeight),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: screenWidth / 5,
                child: ElevatedButton(
                  onPressed: (){
                    Task task = Task('Watering', 0);
                    viewModel.addItemToQueue(task, robot);
                  },
                  child: const Text('Watering'),
                ),
              ),
              Container(
                width: screenWidth / 5,
                child: ElevatedButton(
                  onPressed: (){
                    Task task = Task('Planting', 0);
                    viewModel.addItemToQueue(task, robot);
                  },
                  child: const Text("Planting"),
                ),
              ),
            ],
          ),
          SizedBox(height: oneFourthHeight),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: screenWidth / 5,
                child: ElevatedButton(
                  onPressed: (){
                    Task task = Task('Harvesting', 0);
                    viewModel.addItemToQueue(task, robot);
                  },
                  child: const Text('Harvesting'),
                ),
              ),
              Container(
                width: screenWidth / 5,
                child: ElevatedButton(
                  onPressed: (){
                    Task task = Task('PesticideAdding', 0);
                    viewModel.addItemToQueue(task, robot);
                  },
                  child: const Text("PesticideAdding"),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight / 7),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.blue),
            onPressed: () {
              Navigator.pop(context, taskManager);
            },
          )
        ],
      ),
    );
  }
}
