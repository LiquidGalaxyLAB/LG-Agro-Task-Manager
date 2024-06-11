import 'package:flutter/material.dart';
import 'package:taskmanager/model/crop_db.dart';

import '../model/crop.dart';
import '../widgets/create_crop_widget.dart';

class CropsPage extends StatefulWidget {
  const CropsPage({super.key});

  @override
  State<CropsPage> createState() => _CropsPageState();
}

class _CropsPageState extends State<CropsPage> {
  Future<List<Crop>>? futureCrops;
  final cropRobotDB = CropRobotDB();

  @override
  void initState() {
    super.initState();
    fetchCrops();
  }

  void fetchCrops() {
    setState(() {
      futureCrops = cropRobotDB.fetchAllCrops();
    });
  }

  bool hasValidFormat(String input) {
    RegExp regex = RegExp(r'^\d+-\d+$');
    return regex.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Current Crops'),
        ),
        body: FutureBuilder<List<Crop>>(
          future: futureCrops,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasData) {
                final crops = snapshot.data!;
                return crops.isEmpty
                    ? const Center(
                        child: Text(
                          'No crops...',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      )
                    : ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemCount: crops.length,
                        itemBuilder: (context, index) {
                          final crop = crops[index];
                          return ListTile(
                            title: Text(
                              crop.cropName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Planting Date: ${crop.plantationDates}'),
                                Text(
                                    'Transplanting Date: ${crop.transplantingDates}'),
                                Text(
                                    'Harvesting Date: ${crop.harvestingDates}'),
                                const SizedBox(height: 10),
                                Container(
                                  height: 50,
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 24),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final bool isSelected;
                                      if (hasValidFormat(
                                          crop.plantationDates)) {
                                        final plantingValues =
                                            crop.plantationDates.split('-');
                                        isSelected = int.tryParse(
                                                    plantingValues[0]) ==
                                                index + 1 ||
                                            int.tryParse(plantingValues[1]) ==
                                                index + 1;
                                      } else {
                                        final plantationDate =
                                            int.tryParse(crop.plantationDates);
                                        isSelected =
                                            plantationDate == index + 1;
                                      }

                                      return Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          color: isSelected
                                              ? Colors.green
                                              : Colors.white,
                                        ),
                                        child: Center(
                                          child: Text((index + 1).toString()),
                                        ),
                                      );
                                    },
                                    itemCount: 24,
                                  ),
                                )
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () async {
                                await cropRobotDB.deleteCrop(crop.cropName);
                                fetchCrops();
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => CreateCropWidget(
                                      crop: crop,
                                      onSubmit: (cropName,
                                          plantingDate,
                                          harvestingDate,
                                          transplantingDate) async {
                                        await cropRobotDB.updateCrop(
                                          name: cropName,
                                          plantingDate: plantingDate,
                                          harvestingDate: harvestingDate,
                                          transplantingDate: transplantingDate,
                                        );
                                        fetchCrops();
                                        if (!mounted) return;
                                        Navigator.of(context).pop();
                                      }));
                            },
                          );
                        },
                      );
              }
            }
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => CreateCropWidget(
                      onSubmit: (cropName, plantingDate, harvestingDate,
                          transplantingDate) async {
                        await cropRobotDB.createCrop(
                            cropName: cropName,
                            plantingDate: plantingDate,
                            harvestingDate: harvestingDate,
                            transplantingDate: transplantingDate);
                        if (!mounted) return;
                        fetchCrops();
                        Navigator.of(context).pop();
                      },
                    ));
          },
        ),
      );
}
