import 'package:taskmanager/model/task_manager.dart';
import 'package:taskmanager/services/robots_service.dart';
import '../model/robot.dart';
import '../model/task.dart';

class RobotsViewModel{
  Robot currentRobot = Robot.empty();
  late List<Task>? remainingTasks;
  late TaskManager taskManager;
  late List<Robot> robots;

  void setCurrentRobot(Robot robot){
    currentRobot = robot;
  }

  void fetchTaskManager(){
    taskManager = RobotsService.singleton.taskManager;
  }

  void setCurrentTask(){
    fetchTaskManager();
    if(currentRobot.currentTask != null){
      remainingTasks = taskManager.getRobot(currentRobot.name)?.remainingTasks;
      if(currentRobot.currentTask!.completionPercentage >= 100){
        currentRobot.currentTask = remainingTasks?[0];
        remainingTasks?.removeAt(0);
        taskManager.getRobot(currentRobot.name)?.remainingTasks.removeAt(0);
        currentRobot.taskSimulation();
      }
    }
    else{
      currentRobot.currentTask = taskManager.getRobot(currentRobot.name)?.currentTask;
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
    Robot? currentRobot2 = taskManager.getRobot(currentRobot.name);
    if(currentRobot2 != null && currentRobot2.currentTask != null) {
      currentRobot = currentRobot2;
      return currentRobot.currentTask;
    }
    else {
      return null;
    }
  }

  Future<void> simulateTask() async {
    await currentRobot.taskSimulation();
  }

  List<Task> fetchRemainingTasks() {
    return currentRobot.remainingTasks;
  }

  visualizeTask() {
    if(currentRobot.id == 0 || currentRobot.id == 1){
      RobotsService.singleton.goToLocation("Seròs 1", "Espanya");
    }
    else if(currentRobot.id == 2){
      RobotsService.singleton.goToLocation("Rajauya 1", "India");
    }
    else{
      RobotsService.singleton.goToLocation("Nagjhiri 2", "India");
    }
  }
}
