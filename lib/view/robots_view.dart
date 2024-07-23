import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taskmanager/pages/robot_page.dart';
import 'package:taskmanager/view_models/robots_view_model.dart';
import 'package:taskmanager/widgets/add_robot_widget.dart';

import '../model/robot.dart';
import '../model/task.dart';

class RobotsView extends StatefulWidget {
  const RobotsView({super.key});

  @override
  State<RobotsView> createState() => _RobotsViewState();
}

class _RobotsViewState extends State<RobotsView> {
  TextEditingController itemController = TextEditingController();
  late StreamController<List<Task>> queueController;
  late StreamController<List<Robot>> robotsController;
  late StreamController<Task> _taskController;
  late StreamController<Robot> _currentRobotController;
  RobotsViewModel viewModel = RobotsViewModel();
  late List<Robot> robots;
  late StreamSubscription _periodicSubscription;

  static const Color customGreen = Color(0xFF3E9671);
  static const Color customDarkGrey = Color(0xFF333333);
  static const Color customLightGrey = Color(0xFF4F4F4F);

  @override
  void initState() {
    super.initState();
    queueController = StreamController<List<Task>>.broadcast();
    robotsController = StreamController<List<Robot>>.broadcast();
    _taskController = StreamController<Task>.broadcast();
    _currentRobotController = StreamController<Robot>.broadcast();

    _initializeViewModel();
  }

  Future<void> _initializeViewModel() async {
    await viewModel.setCurrentRobotInit();
    viewModel.setCurrentTask();

    if (viewModel.currentRobot.currentTask != null) {
      _taskController.add(viewModel.currentRobot.currentTask!);
    }
    _currentRobotController.add(viewModel.currentRobot);
    robots = await viewModel.fetchRobots();
    robotsController.add(robots);

    List<Task> initialQueue = viewModel.currentRobot.remainingTasks;
    queueController.add(initialQueue);

    _startPeriodicUpdates();
  }

  void _startPeriodicUpdates() {
    _periodicSubscription =
        Stream.periodic(const Duration(seconds: 2)).listen((_) async {
      if (queueController.isClosed ||
          robotsController.isClosed ||
          _taskController.isClosed ||
          _currentRobotController.isClosed) return;
      viewModel.fetchTaskManager();

      robots = await viewModel.fetchRobots();
      robotsController.add(robots);

      Task? currentTask = viewModel.fetchCurrentTask();
      if (currentTask != null) _taskController.add(currentTask);

      List<Task> remainingTasks = viewModel.fetchRemainingTasks();
      queueController.add(remainingTasks);

      await viewModel.simulateTask();
    });
  }

  @override
  void dispose() {
    queueController.close();
    robotsController.close();
    _taskController.close();
    _currentRobotController.close();
    _periodicSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customDarkGrey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Robots view'),
        backgroundColor: customGreen,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          StreamBuilder<Robot>(
            stream: _currentRobotController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  snapshot.data!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: customGreen,
                  ),
                );
              } else {
                return const Text('Loading...');
              }
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<Task>(
                  stream: _taskController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Text(
                            'Current Task: ${snapshot.data!.taskName.isEmpty ? "Cap" : snapshot.data!.taskName}',
                            style: const TextStyle(
                                color: customGreen, fontSize: 16),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: CircularProgressIndicator(
                              value: snapshot.data!.completionPercentage / 100,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  customGreen),
                              backgroundColor: Colors.grey,
                              strokeWidth: 10.0,
                            ),
                          ),
                          Text(
                            '${snapshot.data!.completionPercentage}% completat',
                            style: const TextStyle(
                                color: customGreen, fontSize: 16),
                          ),
                        ],
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<List<Task>>(
                    stream: queueController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: customLightGrey,
                              child: ListTile(
                                title: Text(
                                  snapshot.data![index].taskName,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    robots = await viewModel.fetchRobots();
                    Robot robot = robots[0];
                    if(context.mounted) {
                      Navigator.pushNamed(
                      context,
                      '/add_task',
                      arguments: {
                        'tmTemp': viewModel.getTaskManager(),
                        'robot': robot,
                      },
                    );
                    }
                    robots = await viewModel.fetchRobots();
                    robotsController.add(robots);

                    viewModel.fetchTaskManager();
                    Task? currentTask = viewModel.fetchCurrentTask();
                    if (currentTask != null) _taskController.add(currentTask);
                    queueController.add(viewModel.fetchRemainingTasks());
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: customGreen),
                  child: const Text(
                    'Add tasks',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    viewModel.visualizeTask();
                    Navigator.pushNamed(context, '/maps_view');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: customGreen),
                  child: const Text(
                    'Visualize',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            height: MediaQuery.of(context).size.height / 10,
            child: StreamBuilder<List<Robot>>(
              stream: robotsController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return RobotPage(
                    robots: snapshot.data!,
                    onRobotSelected: (robot) {
                      viewModel.fetchTaskManager();
                      viewModel.setCurrentRobot(robot);
                      _currentRobotController.add(robot);
                      viewModel.setCurrentTask();
                      if (viewModel.currentRobot.currentTask != null) {
                        _taskController
                            .add(viewModel.currentRobot.currentTask!);
                      }
                      queueController
                          .add(viewModel.currentRobot.remainingTasks);
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return AddRobotWidget(
              onSubmit: (robotName, robotIP, robotSN, field) async {
                await viewModel.createRobot(robotName, robotSN, robotIP, field);
                robots = await viewModel.fetchRobots();
                robotsController.add(robots);
                if(context.mounted) Navigator.of(context).pop();
              },
            );
          }));
        },
        backgroundColor: customGreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
