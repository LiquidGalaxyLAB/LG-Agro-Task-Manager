import 'package:flutter/material.dart';
import 'package:taskmanager/model/crop_db.dart';
import 'package:taskmanager/services/database_service.dart';

import '../model/crop.dart';
import '../widgets/create_crop_widget.dart';

class CropsPage extends StatefulWidget {
  const CropsPage({Key? key}) : super(key: key);

  @override
  State<CropsPage> createState() => _CropsPageState();
}

class _CropsPageState extends State<CropsPage> {
  Future<List<Crop>>? futureCrops;
  final cropRobotDB = CropRobotDB();

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await DataBaseService.getInstance();
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
  Widget build(BuildContext context) {
    const Color customGreen = Color(0xFF3E9671);
    const Color customDarkGrey = Color(0xFF333333);

    return Scaffold(
      backgroundColor: customDarkGrey, // Define el color de fondo de la pantalla
      appBar: AppBar(
        title: const Text('Current Crops'),
        backgroundColor: customGreen,
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
                    color: Colors.white,
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
                          ),),
                        Text('Transplanting Date: ${crop.transplantingDates}',
                          style: const TextStyle(
                            color: customGreen,
                          ),),
                        Text('Harvesting Date: ${crop.harvestingDates}',
                          style: const TextStyle(
                            color: customGreen,
                          ),),
                        const SizedBox(height: 10),
                        Container(
                          height: 50,
                          child: GridView.builder(
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 24,
                            ),
                            itemBuilder:
                                (BuildContext context, int index) {
                              final isSelected = _isSelected(index, crop.plantationDates);

                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  color: isSelected
                                      ? customGreen
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
                              onSubmit: (cropName, plantingDate,
                                  harvestingDate, transplantingDate) async {
                                await cropRobotDB.updateCrop(
                                  cropName: cropName,
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
        backgroundColor: customGreen,
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

  bool _isSelected(int index, String plantingDates) {
    if (!hasValidFormat(plantingDates)) {
      final plantationDate = int.tryParse(plantingDates);
      return plantationDate == index + 1;
    }

    final plantingValues = plantingDates.split('-');
    final start = int.tryParse(plantingValues[0]) ?? 0;
    final end = int.tryParse(plantingValues[1]) ?? 0;

    return index + 1 >= start && index + 1 <= end;
  }
}
