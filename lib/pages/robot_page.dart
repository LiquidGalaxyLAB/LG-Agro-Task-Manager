import 'package:flutter/material.dart';
import '../model/robot.dart';

class RobotPage extends StatefulWidget {
  final List<Robot> robots;
  final Function(Robot) onRobotSelected;
  final Function(Robot) onRobotDeleted;

  const RobotPage({
    super.key,
    required this.robots,
    required this.onRobotSelected,
    required this.onRobotDeleted,
  });

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
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      robot.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        widget.onRobotDeleted(robot);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
