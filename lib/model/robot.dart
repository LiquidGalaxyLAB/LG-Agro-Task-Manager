import 'package:taskmanager/model/task.dart';
import 'package:isar/isar.dart';

part 'robot.g.dart';

@collection
class Robot {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment
  String name;
  String serialNumber;
  String robotIP;
  @ignore
  Task? currentTask;
  @ignore
  List<Task> remainingTasks = [];

  Robot({
    required this.name,
    required this.serialNumber,
    required this.robotIP}) {
    _checkAndAssignTask();
  }

  factory Robot.empty(){
    return Robot(name: 'empty', serialNumber: '9999', robotIP: '9999');
  }

  Future<void> taskSimulation() async {
    await currentTask?.simulateCompletion();
    currentTask = null;
    _checkAndAssignTask();
  }

  void addTask(Task t){
    remainingTasks.add(t);
    _checkAndAssignTask();
  }

  void setCurrentTask(Task t){
    currentTask = t;
  }

  void _checkAndAssignTask() {
    if (currentTask == null && remainingTasks.isNotEmpty) {
      currentTask = remainingTasks[0];
      remainingTasks.removeAt(0);
    }
  }
}