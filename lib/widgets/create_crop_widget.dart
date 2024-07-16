import 'package:flutter/material.dart';

import '../model/crop.dart';

class CreateCropWidget extends StatefulWidget {
  final Crop? crop;
  final Function(String, String, String, String) onSubmit;

  const CreateCropWidget({
    super.key,
    this.crop,
    required this.onSubmit,
  });

  @override
  State<CreateCropWidget> createState() => _CreateCropWidgetState();
}

class _CreateCropWidgetState extends State<CreateCropWidget> {
  final formKey = GlobalKey<FormState>();
  final cropNameController = TextEditingController();
  final plantingDateController1 = TextEditingController();
  final plantingDateController2 = TextEditingController();
  final transplantingDateController1 = TextEditingController();
  final transplantingDateController2 = TextEditingController();
  final harvestingDateController1 = TextEditingController();
  final harvestingDateController2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.crop != null) {
      cropNameController.text = widget.crop?.cropName ?? '';

      final plantingValues = widget.crop?.plantationDates.split('-');
      if (plantingValues?.length == 2) {
        plantingDateController1.text =
            widget.crop?.plantationDates.split('-')[0] ?? '';
        plantingDateController2.text =
            widget.crop?.plantationDates.split('-')[1] ?? '';
      } else {
        plantingDateController1.text =
            plantingDateController2.text = widget.crop?.plantationDates ?? '';
      }

      final transplantingValues = widget.crop?.transplantingDates.split('-');
      if (transplantingValues?.length == 2) {
        transplantingDateController1.text =
            widget.crop?.transplantingDates.split('-')[0] ?? '';
        transplantingDateController2.text =
            widget.crop?.transplantingDates.split('-')[1] ?? '';
      } else {
        transplantingDateController1.text = transplantingDateController2.text =
            widget.crop?.transplantingDates ?? '';
      }

      final harvestingValues = widget.crop?.harvestingDates.split('-');
      if (harvestingValues?.length == 2) {
        harvestingDateController1.text =
            widget.crop?.harvestingDates.split('-')[0] ?? '';
        harvestingDateController2.text =
            widget.crop?.harvestingDates.split('-')[1] ?? '';
      } else {
        harvestingDateController1.text =
            harvestingDateController2.text = widget.crop?.harvestingDates ?? '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.crop != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit Crop' : 'Add Crop'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                autofocus: true,
                controller: cropNameController,
                decoration: const InputDecoration(hintText: 'Crop Name'),
                validator: (value) => value != null && value.isEmpty
                    ? 'Crop Name is required'
                    : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: plantingDateController1,
                      decoration:
                          const InputDecoration(hintText: 'Planting Date'),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final intValue = int.tryParse(value);
                          if (intValue == null ||
                              intValue < 1 ||
                              intValue > 24) {
                            return 'Value must be between 1 and 24';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: TextFormField(
                      controller: plantingDateController2,
                      decoration:
                          const InputDecoration(hintText: 'Planting Date'),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final intValue = int.tryParse(value);
                          if (intValue == null ||
                              intValue < 1 ||
                              intValue > 24) {
                            return 'Value must be between 1 and 24';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: transplantingDateController1,
                      decoration:
                          const InputDecoration(hintText: 'Transplanting Date'),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final intValue = int.tryParse(value);
                          if (intValue == null ||
                              intValue < 1 ||
                              intValue > 24) {
                            return 'Value must be between 1 and 24';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: TextFormField(
                      controller: transplantingDateController2,
                      decoration:
                          const InputDecoration(hintText: 'Transplanting Date'),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final intValue = int.tryParse(value);
                          if (intValue == null ||
                              intValue < 1 ||
                              intValue > 24) {
                            return 'Value must be between 1 and 24';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: harvestingDateController1,
                      decoration:
                          const InputDecoration(hintText: 'Harvesting Date'),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final intValue = int.tryParse(value);
                          if (intValue == null ||
                              intValue < 1 ||
                              intValue > 24) {
                            return 'Value must be between 1 and 24';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: TextFormField(
                      controller: harvestingDateController2,
                      decoration:
                          const InputDecoration(hintText: 'Harvesting Date'),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final intValue = int.tryParse(value);
                          if (intValue == null ||
                              intValue < 1 ||
                              intValue > 24) {
                            return 'Value must be between 1 and 24';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
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
            final cropName = cropNameController.text;
            final plantingDate =
                '${plantingDateController1.text}-${plantingDateController2.text}';
            final harvestingDate =
                '${harvestingDateController1.text}-${harvestingDateController2.text}';
            final transplantingDate =
                '${transplantingDateController1.text}-${transplantingDateController2.text}';

            if (formKey.currentState!.validate()) {
              widget.onSubmit(
                  cropName, plantingDate, harvestingDate, transplantingDate);
              setState(() {});
              Navigator.pop(context);
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
