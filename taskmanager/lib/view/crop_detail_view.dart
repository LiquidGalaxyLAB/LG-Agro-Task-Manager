import 'package:flutter/material.dart';
import 'package:taskmanager/model/crop_db.dart';
import '../model/crop.dart';
import '../widgets/create_crop_widget.dart';
import '../services/database_service.dart';

class CropDetailView extends StatelessWidget {
  final Crop crop;
  final Function onUpdate;
  final CropRobotDB cropRobotDB;

  const CropDetailView({Key? key, required this.crop, required this.onUpdate, required this.cropRobotDB}) : super(key: key);

  bool hasValidFormat(String input) {
    RegExp regex = RegExp(r'^\d+-\d+$');
    return regex.hasMatch(input);
  }

  bool _isSelected(int index, String dates) {
    if (!hasValidFormat(dates)) {
      final date = int.tryParse(dates);
      return date == index + 1;
    }

    final dateValues = dates.split('-');
    final start = int.tryParse(dateValues[0]) ?? 0;
    final end = int.tryParse(dateValues[1]) ?? 0;

    return index + 1 >= start && index + 1 <= end;
  }

  @override
  Widget build(BuildContext context) {
    const Color customGreen = Color(0xFF3E9671);
    const Color customDarkGrey = Color(0xFF333333);

    return Scaffold(
      appBar: AppBar(
        title: Text(crop.cropName),
        backgroundColor: customGreen,
      ),
      backgroundColor: customDarkGrey,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Planting Date: ${crop.plantationDates}', style: const TextStyle(color: customGreen)),
            _buildDateGrid(crop.plantationDates, customGreen),
            const SizedBox(height: 20),
            Text('Transplanting Date: ${crop.transplantingDates}', style: const TextStyle(color: customGreen)),
            _buildDateGrid(crop.transplantingDates, customGreen),
            const SizedBox(height: 20),
            Text('Harvesting Date: ${crop.harvestingDates}', style: const TextStyle(color: customGreen)),
            _buildDateGrid(crop.harvestingDates, customGreen),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CreateCropWidget(
                    crop: crop,
                    onSubmit: (cropName, plantingDate, harvestingDate, transplantingDate) async {
                      await CropRobotDB().updateCrop(
                        cropName: cropName,
                        plantingDate: plantingDate,
                        harvestingDate: harvestingDate,
                        transplantingDate: transplantingDate,
                      );
                      onUpdate();
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: customGreen,
              ),
              child: const Text('Edit Crop'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateGrid(String dates, Color customGreen) {
    return Container(
      height: 50,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 24,
        ),
        itemBuilder: (BuildContext context, int index) {
          final isSelected = _isSelected(index, dates);

          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: isSelected ? customGreen : Colors.white,
            ),
            child: Center(
              child: Text((index + 1).toString()),
            ),
          );
        },
        itemCount: 24,
      ),
    );
  }
}
