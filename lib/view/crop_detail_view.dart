import 'package:flutter/material.dart';
import 'package:taskmanager/view_models/crop_detail_view_model.dart';

import '../model/crop.dart';
import '../widgets/create_crop_widget.dart';

class CropDetailView extends StatefulWidget {
  final Crop crop;
  final Function onUpdate;

  const CropDetailView({super.key, required this.crop, required this.onUpdate});

  @override
  State<CropDetailView> createState() => _CropDetailViewState();
}

class _CropDetailViewState extends State<CropDetailView> {
  final CropDetailViewModel viewModel = CropDetailViewModel();

  @override
  Widget build(BuildContext context) {
    const Color customGreen = Color(0xFF3E9671);
    const Color customDarkGrey = Color(0xFF333333);
    const Color overlapColor = Colors.orange;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.crop.cropName),
        backgroundColor: customGreen,
      ),
      backgroundColor: customDarkGrey,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
                'Planting Date:',
                viewModel.getCropPlantationDate(widget.crop),
                customGreen,
                overlapColor),
            const SizedBox(height: 20),
            _buildSectionHeader(
                'Transplanting Date:',
                viewModel.getCropTransplantingDate(widget.crop),
                customGreen,
                overlapColor),
            const SizedBox(height: 20),
            _buildSectionHeader(
                'Harvesting Date:',
                viewModel.getCropHarvestingDate(widget.crop),
                customGreen,
                overlapColor),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => CreateCropWidget(
                      crop: widget.crop,
                      onSubmit: (cropName, plantingDate, harvestingDate,
                          transplantingDate) async {
                        final int cropID = viewModel.searchCropID(cropName);
                        await viewModel.updateCrop(cropID, cropName,
                            plantingDate, harvestingDate, transplantingDate);
                        setState(() {});
                        widget.onUpdate();
                        if (context.mounted) Navigator.of(context).pop();
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  backgroundColor: customGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Edit Crop', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 30),
            _buildLegend(customGreen, overlapColor, customDarkGrey),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
      String title, String dates, Color customGreen, Color overlapColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: customGreen,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildDateGrid(dates, customGreen, overlapColor),
      ],
    );
  }

  Widget _buildDateGrid(String dates, Color customGreen, Color overlapColor) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF4F4F4F),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: customGreen, width: 1.5),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 24,
        ),
        itemBuilder: (BuildContext context, int index) {
          final isSelected = viewModel.isSelected(index, dates);
          final isInCurrentFortnight = viewModel.isInCurrentFortnight(index);
          final isOverlap = isSelected && isInCurrentFortnight;

          return Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: isOverlap
                  ? overlapColor
                  : (isSelected
                      ? customGreen
                      : (isInCurrentFortnight
                          ? const Color(0xFF4F4F4F).withOpacity(0.5)
                          : Colors.white)),
            ),
            child: Center(
              child: Text(
                (index + 1).toString(),
                style: TextStyle(
                  color: isOverlap
                      ? Colors.black
                      : (isSelected || isInCurrentFortnight
                          ? Colors.white
                          : customGreen),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
        itemCount: 24,
      ),
    );
  }

  Widget _buildLegend(
      Color customGreen, Color overlapColor, Color customDarkGrey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Legend:',
          style: TextStyle(
            color: customGreen,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildLegendItem(customGreen, 'Selected Dates'),
            const SizedBox(width: 20),
            _buildLegendItem(
                const Color(0xFF4F4F4F).withOpacity(0.5), 'Current Fortnight'),
            const SizedBox(width: 20),
            _buildLegendItem(overlapColor, 'Overlap'),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
