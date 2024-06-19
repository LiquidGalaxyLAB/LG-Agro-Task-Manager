import 'package:taskmanager/model/task_manager.dart';
import 'package:taskmanager/services/robots_service.dart';
import '../model/robot.dart';
import '../model/task.dart';

class RobotsViewModel{
  Robot currentRobot = Robot.empty();
  Task? currentTask = Task("", 0);
  late List<Task>? remainingTasks;
  late TaskManager taskManager;
  late List<Robot> robots;

  void setCurrentRobot(Robot robot){
    currentRobot = robot;
  }

  void setCurrentTask(){
    if(currentRobot.currentTask != null){
      currentTask = currentRobot.currentTask;
      remainingTasks = currentRobot.remainingTasks;
    }
  }

  Future<List<Robot>> fetchRobots() async{
    return RobotsService.singleton.fetchRobots();
  }

  TaskManager getTaskManager() {
    taskManager = RobotsService.singleton.getTaskManager();
    return taskManager;
  }

  void setTaskManager(TaskManager tm){
    taskManager = tm;
  }

  Future<void> createRobot(String robotName, String robotIP, String serialNumber) async {
    RobotsService.singleton.createRobot(robotName, robotIP, serialNumber);
  }

  Future<void> setCurrentRobotInit() async {
    robots = await fetchRobots();
    if(robots.isNotEmpty){
      currentRobot = robots[0];
    }
  }

  Task? fetchCurrentTask()  {
    taskManager = RobotsService.singleton.getTaskManager();
    currentRobot = taskManager.getRobot(currentRobot.name)!;
    currentTask = currentRobot.currentTask;
    return currentTask;
  }

  Future<void> simulateTask() async {
    await currentRobot.taskSimulation();

  }

  List<Task> fetchRemainingTasks() {
    return currentRobot.remainingTasks;
  }
}
