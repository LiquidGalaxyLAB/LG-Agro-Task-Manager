class Task {
  String taskName;
  double completionPercentage;

  Task(this.taskName, this.completionPercentage);

  void changeTask(String newTask) {
    taskName = newTask;
    completionPercentage = 0;
  }

  void setName(String taskName) {
    this.taskName = taskName;
  }

  void setComplete(double completion) {
    completionPercentage = completion;
  }
}