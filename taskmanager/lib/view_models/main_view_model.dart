import 'package:intl/intl.dart';
import 'package:taskmanager/model/crop_db.dart';
import 'package:taskmanager/services/database_service.dart';

import '../model/crop.dart';

class MainViewModel{
  int currentFortnight = 0;
  List<Crop> cropsInCurrentFortnight = [];
  final CropRobotDB cropRobotDB = CropRobotDB();

  void fetchCrops() async {
    List<Crop> crops = await cropRobotDB.fetchAllCrops();
    currentFortnight = _getCurrentFortnight();
    cropsInCurrentFortnight = _filterCropsInCurrentFortnight(crops);
  }

  int _getCurrentFortnight() {
    DateTime now = DateTime.now();
    int dayOfYear = int.parse(DateFormat("D").format(now));
    return (dayOfYear / 15).ceil();
  }

  bool _isInCurrentFortnight(String dateRange) {
    List<String> dates = dateRange.split('-');
    int start = int.parse(dates[0]);
    int end = int.parse(dates[1]);
    return start <= currentFortnight && currentFortnight <= end;
  }

  List<Crop> _filterCropsInCurrentFortnight(List<Crop> crops) {
    return crops.where((crop) {
      return _isInCurrentFortnight(crop.plantationDates) ||
          _isInCurrentFortnight(crop.transplantingDates) ||
          _isInCurrentFortnight(crop.harvestingDates);
    }).toList();
  }

  String getTaskText(Crop crop) {
    if (_isInCurrentFortnight(crop.plantationDates)) {
      return "It's Planting time!";
    } else if (_isInCurrentFortnight(crop.transplantingDates)) {
      return "It's Transplanting time!";
    } else if (_isInCurrentFortnight(crop.harvestingDates)) {
      return "It's Harvesting time!";
    } else {
      return "";
    }
  }
}