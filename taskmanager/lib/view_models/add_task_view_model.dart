import 'package:taskmanager/services/robots_service.dart';

import '../model/robot.dart';
import '../model/task.dart';
import '../model/task_manager.dart';

class AddTaskViewModel{
  TaskManager taskManager = RobotsService.singleton.getTaskManager();
  late Robot robot;

  void updateTaskManager(){
    taskManager = RobotsService.singleton.getTaskManager();
  }

  Future<void> addItemToQueue(Task task, Robot robot) async {
    updateTaskManager();
    taskManager.addTaskToRobot(task, robot.name);
    Robot? r = taskManager.getRobot(robot.name);
    RobotsService.singleton.setTaskManager(taskManager);
  }
}