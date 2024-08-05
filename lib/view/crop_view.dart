import 'package:flutter/material.dart';
import 'package:taskmanager/view_models/crop_view_model.dart';

import '../model/crop.dart';
import '../widgets/create_crop_widget.dart';
import 'crop_detail_view.dart';

class CropView extends StatefulWidget {
  const CropView({super.key});

  @override
  State<CropView> createState() => _CropViewState();
}

class _CropViewState extends State<CropView> {
  final CropViewModel viewModel = CropViewModel();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    viewModel.initializeDatabase();
    setState(() {
      viewModel.fetchCrops();
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color customGreen = Color(0xFF3E9671);
    const Color customDarkGrey = Color(0xFF333333);
    const Color customLightGrey = Color(0xFF4F4F4F);

    return Scaffold(
      backgroundColor: customDarkGrey,
      appBar: AppBar(
        title: const Text('Current Crops'),
        backgroundColor: customGreen,
      ),
      body: FutureBuilder<List<Crop>>(
        future: viewModel.getFutureCrops(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: customGreen));
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red)));
          } else if (snapshot.hasData) {
            final crops = snapshot.data!;
            return crops.isEmpty
                ? const Center(
                    child: Text(
                      'No crops...',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    separatorBuilder: (context, index) =>
                        const Divider(color: customLightGrey),
                    itemCount: crops.length,
                    itemBuilder: (context, index) {
                      final crop = crops[index];
                      return Card(
                        color: customLightGrey,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          title: Text(
                            crop.cropName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: customGreen,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Planting Date: ${crop.plantationDates}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Transplanting Date: ${crop.transplantingDates}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Harvesting Date: ${crop.harvestingDates}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              await viewModel.deleteCrops(crop.cropName);
                              viewModel.fetchCrops();
                              setState(() {});
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CropDetailView(
                                  crop: crop,
                                  onUpdate: () async {
                                    viewModel.fetchCrops();
                                    setState(() {});
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
          } else {
            return const Center(
                child: Text('No crops available',
                    style: TextStyle(color: Colors.white)));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: customGreen,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => CreateCropWidget(
              onSubmit: (cropName, plantingDate, harvestingDate,
                  transplantingDate) async {
                await viewModel.createCrop(
                    cropName, plantingDate, harvestingDate, transplantingDate);
                viewModel.fetchCrops();
                setState(() {});
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
