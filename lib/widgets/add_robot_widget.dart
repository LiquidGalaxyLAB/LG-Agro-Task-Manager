import 'package:flutter/material.dart';
import 'package:taskmanager/services/robots_service.dart';

import '../model/robot.dart';

class AddRobotWidget extends StatefulWidget {
  final Robot? robot;
  final Function(String, String, String, String) onSubmit;

  const AddRobotWidget({
    super.key,
    this.robot,
    required this.onSubmit,
  });

  @override
  State<AddRobotWidget> createState() => _AddRobotWidgetState();
}

class _AddRobotWidgetState extends State<AddRobotWidget> {
  final formKey = GlobalKey<FormState>();
  final robotNameController = TextEditingController();
  final robotIPController = TextEditingController();
  final robotSNController = TextEditingController();
  String? selectedField;
  final List<String> fieldOptions = [
    'Seròs 1',
    'Seròs 2',
    'Seròs 3',
    'Anaquela del Ducado 1',
    'Anaquela del Ducado 2',
    'Anaquela del Ducado 3',
    'Soria 1',
    'Soria 2',
    'Soria 3',
    'Rajauya 1',
    'Rajauya 2',
    'Rajauya 3',
    'Nagjhiri 1',
    'Nagjhiri 2',
    'Nagjhiri 3',
    'Karur 1',
    'Karur 2',
    'Karur 3'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.robot != null) {
      robotNameController.text = widget.robot?.name ?? '';
      robotIPController.text = widget.robot?.robotIP ?? '';
      robotSNController.text = widget.robot?.serialNumber ?? '';
      selectedField =
          widget.robot?.field ?? fieldOptions[0]; // Ensure it's in the list
    } else {
      selectedField = fieldOptions[0]; // Set default value
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.robot != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit Robot' : 'Add Robot'),
      content: SingleChildScrollView(
        child: Form(
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
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
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedField,
                decoration: const InputDecoration(hintText: 'Select Field'),
                items: fieldOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedField = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final robotName = robotNameController.text;
            final robotIP = robotIPController.text;
            final robotSN = robotSNController.text;

            if (formKey.currentState!.validate()) {
              widget.onSubmit(robotName, robotIP, robotSN, selectedField!);
              Navigator.pop(context);
            }
            RobotsService.singleton.fetchRobots();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
