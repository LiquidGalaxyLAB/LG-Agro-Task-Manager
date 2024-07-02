import 'package:flutter/material.dart';
import 'package:taskmanager/services/robots_service.dart';

import '../model/robot.dart';

class AddRobotWidget extends StatefulWidget {
  final Robot? robot;
  final Function(String, String, String) onSubmit;

  const AddRobotWidget({
    Key? key,
    this.robot,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<AddRobotWidget> createState() => _AddRobotWidgetState();
}

class _AddRobotWidgetState extends State<AddRobotWidget> {
  final formKey = GlobalKey<FormState>();
  final robotNameController = TextEditingController();
  final robotIPController = TextEditingController();
  final robotSNController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.robot != null) {
      robotNameController.text = widget.robot?.name ?? '';
      robotIPController.text = widget.robot?.robotIP ?? '';
      robotSNController.text = widget.robot?.serialNumber ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.robot != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit Robot' : 'Add Robot'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: robotNameController,
              decoration: const InputDecoration(hintText: "Robot name"),
              validator: (value) {
                if (value == "") {
                  return 'El nom del robot és obligatori';
                }
                return null;
              },
            ),
            TextFormField(
              controller: robotIPController,
              decoration: const InputDecoration(hintText: 'Robot IP'),
              validator: (value) {
                if (value == "") {
                  return "L'IP és obligatòria";
                }
                return null;
              },
            ),
            TextFormField(
              controller: robotSNController,
              decoration:
                  const InputDecoration(hintText: 'Robot serial number'),
              validator: (value) {
                if (value == "") {
                  return 'El nombre de sèrie és obligatori';
                }
                return null;
              },
            )
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
            )),
        TextButton(
          onPressed: () {
            final robotName = robotNameController.text;
            final robotIP = robotIPController.text;
            final robotSN = robotSNController.text;

            if (formKey.currentState!.validate()) {
              widget.onSubmit(robotName, robotIP, robotSN);
            }
            RobotsService.singleton.fetchRobots();
          },
          child: const Text('OK'),
        )
      ],
    );
  }
}
