import 'package:flutter/material.dart';

import '../model/crop_db.dart';
import '../model/robot.dart';
import '../widgets/add_robot_widget.dart';

class RobotPage extends StatefulWidget {
  final List<Robot> robots;

  const RobotPage({Key? key, required this.robots}) : super(key: key);

  @override
  State<RobotPage> createState() => _RobotPageState();
}

class _RobotPageState extends State<RobotPage> {
  final cropRobotDB = CropRobotDB();

  @override
  void initState(){
    super.initState();
    cropRobotDB.fetchAllRobots();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.robots.length,
        itemBuilder: (context, index) {
          final robot = widget.robots[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: GestureDetector(
                onTap: () {
                  print ("a");
                },
                child: Center(
                  child: Text(
                    robot.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          );
        },
      );
  }
}
