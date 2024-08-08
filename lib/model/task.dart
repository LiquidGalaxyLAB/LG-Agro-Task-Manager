class Task {
  String taskName;
  double completionPercentage;
  Function(double)? callback;

  Task(this.taskName, this.completionPercentage);

  void subscribeChanges(Function(double) callback) {
    this.callback = callback;
  }

  Future<void> simulateCompletion() async {
    completionPercentage = 0;
    while (completionPercentage < 100) {
      await Future.delayed(const Duration(seconds: 2));
      completionPercentage += 2;
      if (callback != null) {
        callback!(completionPercentage);
      }
    }
  }

  void removeCallback() {
    callback = null;
  }
}
