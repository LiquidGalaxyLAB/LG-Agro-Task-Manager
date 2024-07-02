import 'package:flutter/material.dart';
import 'package:taskmanager/view_models/crop_view_model.dart';
import '../model/crop.dart';
import 'crop_detail_view.dart';
import '../widgets/create_crop_widget.dart';

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

  Future<void> _initialize() async {
    await viewModel.initializeDatabase();
    setState(() {
      viewModel.fetchCrops();
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color customGreen = Color(0xFF3E9671);
    const Color customDarkGrey = Color(0xFF333333);

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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
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
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: crops.length,
              itemBuilder: (context, index) {
                final crop = crops[index];
                return ListTile(
                  title: Text(
                    crop.cropName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: customGreen,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Planting Date: ${crop.plantationDates}',
                        style: const TextStyle(
                          color: customGreen,
                        ),
                      ),
                      Text(
                        'Transplanting Date: ${crop.transplantingDates}',
                        style: const TextStyle(
                          color: customGreen,
                        ),
                      ),
                      Text(
                        'Harvesting Date: ${crop.harvestingDates}',
                        style: const TextStyle(
                          color: customGreen,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      // await cropRobotDB.deleteCrop(crop.cropName);
                      await viewModel.fetchCrops();
                      setState(() {}); // afegir setState per actualitzar la UI
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
                            await viewModel.fetchCrops();
                            setState(() {}); // afegir setState per actualitzar la UI
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No crops available'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: customGreen,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => CreateCropWidget(
              onSubmit: (cropName, plantingDate, harvestingDate, transplantingDate) async {
                await viewModel.createCrop(cropName, plantingDate, harvestingDate, transplantingDate);
                await viewModel.fetchCrops();
                setState(() {}); // afegir setState per actualitzar la UI
                Navigator.of(context).pop();
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
