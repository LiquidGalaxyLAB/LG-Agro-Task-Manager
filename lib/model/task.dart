
class Task {
  String taskName;
  double completionPercentage;

  Task(this.taskName, this.completionPercentage);

  Future<void> simulateCompletion() async {
    completionPercentage = 0;
    while(completionPercentage < 100){
      await Future.delayed(const Duration(seconds: 2));
      completionPercentage += 20;
    }
  }
}