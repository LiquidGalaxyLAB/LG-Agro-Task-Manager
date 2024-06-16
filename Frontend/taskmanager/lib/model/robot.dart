import 'package:taskmanager/model/task.dart';

class Robot{
  int robotNumber;
  String name;
  String serialNumber;
  String robotIP;
  Task? currentTask;
  List<Task> remainingTasks = [];

  Robot({
    required this.robotNumber,
    required this.name,
    required this.serialNumber,
    required this.robotIP}) {
    _checkAndAssignTask();
  }

  void taskSimulation(){
    currentTask?.simulateCompletion();
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

  factory Robot.fromSqfliteDatabase(Map<String, dynamic> map) => Robot(
    robotNumber: map['robotNumber'],
    name: map['robotName'],
    serialNumber: map['serialCode'],
    robotIP: map['robotIP'],
  );

  void _checkAndAssignTask() {
    if (currentTask == null && remainingTasks.isNotEmpty) {
      currentTask = remainingTasks[0];
      remainingTasks.removeAt(0);
    }
  }
}