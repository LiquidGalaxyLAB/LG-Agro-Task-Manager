class Task {
  String taskName;
  double completionPercentage;

  Task(this.taskName, this.completionPercentage);

  void simulateCompletion(){
    completionPercentage = 0;
    while(completionPercentage < 100){
      completionPercentage += 2;
    }
  }
}