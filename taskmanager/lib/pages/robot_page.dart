import 'package:flutter/material.dart';
import '../model/robot.dart';

class RobotPage extends StatefulWidget {
  final List<Robot> robots;
  final Function(Robot) onRobotSelected;

  const RobotPage({Key? key, required this.robots, required this.onRobotSelected}) : super(key: key);

  @override
  State<RobotPage> createState() => _RobotPageState();
}

class _RobotPageState extends State<RobotPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.robots.length,
      itemBuilder: (context, index) {
        final robot = widget.robots[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: GestureDetector(
            onTap: () {
              widget.onRobotSelected(robot);
            },
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8.0),
              ),
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
