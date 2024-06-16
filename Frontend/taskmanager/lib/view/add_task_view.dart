import 'package:flutter/material.dart';
import 'package:taskmanager/model/task_manager.dart';

import '../model/robot.dart';
import '../model/task.dart';

class AddTaskView extends StatelessWidget {
  final TaskManager taskManager;
  final Robot robot;
  const AddTaskView({super.key, required this.taskManager, required this.robot});

  Future<void> addItemToQueue(Task task, Robot robot) async {
    taskManager.addTaskToRobot(task, robot);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final oneFourthHeight = screenHeight / 4;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
                    addItemToQueue(task, robot);
                  },
                  child: Text('Watering'),
                ),
              ),
              Container(
                width: screenWidth / 5,
                child: ElevatedButton(
                  onPressed: (){
                    Task task = Task('Planting', 0);
                    addItemToQueue(task, robot);
                  },
                  child: Text("Planting"),
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
                    addItemToQueue(task, robot);
                  },
                  child: Text('Harvesting'),
                ),
              ),
              Container(
                width: screenWidth / 5,
                child: ElevatedButton(
                  onPressed: (){
                    Task task = Task('PesticideAdding', 0);
                    addItemToQueue(task, robot);
                  },
                  child: Text("PesticideAdding"),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight / 7),
          IconButton(
            icon: Icon(Icons.home, color: Colors.blue),
            onPressed: () {
              Navigator.pop(context, taskManager);
            },
          )
        ],
      ),
    );
  }
}
