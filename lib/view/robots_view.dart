import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/pages/robot_page.dart';
import 'package:taskmanager/view_models/robots_view_model.dart';
import 'package:taskmanager/widgets/add_robot_widget.dart';

import '../model/robot.dart';

class RobotsView extends StatefulWidget {
  const RobotsView({super.key});

  @override
  State<RobotsView> createState() => _RobotsViewState();
}

class _RobotsViewState extends State<RobotsView> {
  final TextEditingController itemController = TextEditingController();
  final RobotsViewModel viewModel = RobotsViewModel();
  double percentage = 0.0;

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
                viewModel.getCurrentRobot().name,
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
                      'Current Task: ${viewModel.getCurrentRobot().currentTask != null ? viewModel.getCurrentRobot().currentTask?.taskName : ""}',
                      style: const TextStyle(color: customGreen, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    viewModel.getCurrentRobot().currentTask != null
                        ? Column(
                            children: [
                              CircularPercentIndicator(
                                radius: 50.0,
                                lineWidth: 10.0,
                                percent: percentage /
                                    100,
                                center: Text(
                                  '${percentage.toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                progressColor: customGreen,
                                backgroundColor: customLightGrey,
                              ),
                              const SizedBox(height: 10),
                            ],
                          )
                        : const Text(
                            'No current task',
                            style: TextStyle(color: customGreen, fontSize: 16),
                          ),
                    const SizedBox(height: 20),
                    SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount:
                              viewModel.getCurrentRobot().remainingTasks.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: customLightGrey,
                              child: ListTile(
                                title: Text(
                                  viewModel
                                      .getCurrentRobot()
                                      .remainingTasks[index]
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
                        if (context.mounted) {
                          await Navigator.pushNamed(
                            context,
                            '/add_task',
                            arguments: {
                              'tmTemp': viewModel.getTaskManager(),
                              'robot': viewModel.getCurrentRobot(),
                            },
                          );
                        }
                        viewModel.update();
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
                            'field': viewModel.getCurrentRobot().field,
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
                    robots: viewModel.getRobots(),
                    onRobotSelected: (robot) {
                      viewModel.fetchTaskManager();
                      viewModel.setCurrentRobot(robot);
                      robot.currentTask?.callback = updateValues;
                    },
                    onRobotDeleted: (Robot r) async {
                      await viewModel.deleteRobot();
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

  void updateValues(double newValue) {
    setState(() {
      percentage = newValue;
    });
  }
}
