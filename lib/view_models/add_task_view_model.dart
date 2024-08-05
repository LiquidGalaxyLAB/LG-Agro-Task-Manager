import 'package:taskmanager/services/robots_service.dart';

import '../model/robot.dart';
import '../model/task.dart';
import '../model/task_manager.dart';

class AddTaskViewModel {
  TaskManager taskManager = RobotsService.singleton.getTaskManager();

  Future<void> addItemToQueue(Task task, Robot robot) async {
    taskManager.addTaskToRobot(task, robot.name);
    taskManager.getRobot(robot.name)?.taskSimulation();
    RobotsService.singleton.setTaskManager(taskManager);
  }
}
