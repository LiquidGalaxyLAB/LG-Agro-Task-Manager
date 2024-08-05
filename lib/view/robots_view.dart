import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/pages/robot_page.dart';
import 'package:taskmanager/view_models/robots_view_model.dart';
import 'package:taskmanager/widgets/add_robot_widget.dart';

import '../model/robot.dart';
import '../utils/logger.dart';

class RobotsView extends StatefulWidget {
  const RobotsView({super.key});

  @override
  State<RobotsView> createState() => _RobotsViewState();
}

class _RobotsViewState extends State<RobotsView> {
  TextEditingController itemController = TextEditingController();
  late List<Robot> robots;

  static const Color customGreen = Color(0xFF3E9671);
  static const Color customDarkGrey = Color(0xFF333333);
  static const Color customLightGrey = Color(0xFF4F4F4F);

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
      body: Consumer<RobotsViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              const SizedBox(height: 20),
              Text(
                viewModel.currentRobot.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: customGreen,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Current Task: ${viewModel.currentRobot.currentTask != null ? "Cap" : viewModel.currentRobot.currentTask?.taskName}',
                      style: const TextStyle(color: customGreen, fontSize: 16),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount:
                              viewModel.currentRobot.remainingTasks.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: customLightGrey,
                              child: ListTile(
                                title: Text(
                                  viewModel.currentRobot.remainingTasks[index]
                                      .taskName,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            );
                          },
                        )),
                    ElevatedButton(
                      onPressed: () async {
                        Robot robot = viewModel.currentRobot;
                        if (context.mounted) {
                          await Navigator.pushNamed(
                            context,
                            '/add_task',
                            arguments: {
                              'tmTemp': viewModel.getTaskManager(),
                              'robot': robot,
                            },
                          );
                        }
                        robots = await viewModel.fetchRobots();

                        viewModel.fetchTaskManager();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: customGreen),
                      child: const Text(
                        'Add tasks',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        viewModel.visualizeTask();
                        Navigator.pushNamed(
                          context,
                          '/maps_view',
                          arguments: {
                            'field': viewModel.currentRobot.field,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: customGreen),
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
                  child: RobotPage(
                    robots: viewModel.robots,
                    onRobotSelected: (robot) {
                      Logger.printInDebug('Selected robot: ${robot.name}');
                      viewModel.fetchTaskManager();
                      viewModel.setCurrentRobot(robot);
                      Logger.printInDebug("robots: ${robot.name}");
                      viewModel.setCurrentTask();
                    },
                    onRobotDeleted: (Robot r) async {
                      await viewModel.deleteRobot();
                      robots = await viewModel.fetchRobots();
                    },
                  )),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return AddRobotWidget(
              onSubmit: (robotName, robotIP, robotSN, field) async {
                final viewModel =
                    Provider.of<RobotsViewModel>(context, listen: false);
                await viewModel.createRobot(robotName, robotSN, robotIP, field);
                robots = await viewModel.fetchRobots();
                if (context.mounted) Navigator.of(context).pop();
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
