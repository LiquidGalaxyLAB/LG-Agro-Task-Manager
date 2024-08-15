import 'package:intl/intl.dart';
import 'package:taskmanager/services/crop_service.dart';
import 'package:taskmanager/services/lg_service.dart';

import '../model/crop.dart';

class MainViewModel {
  int currentFortnight = 0;

  List<Crop> getCropsInCurrentFortnight() {
    List<Crop> crops = CropService.singleton.getCrops();
    currentFortnight = _getCurrentFortnight();
    return _filterCropsInCurrentFortnight(crops);
  }

  int _getCurrentFortnight() {
    DateTime now = DateTime.now();
    int dayOfYear = int.parse(DateFormat("D").format(now));
    return (dayOfYear / 15).ceil();
  }

  bool _isInCurrentFortnight(String dateRange) {
    List<String> dates = dateRange.split('-');
    if (dates.length != 2) return false;

    int? start = int.tryParse(dates[0]);
    int? end = int.tryParse(dates[1]);

    if (start == null || end == null) return false;
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

  String _getInSeasonTaskName(Crop crop) {
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

  Future<void> sendPendingTasks() async {
    final List<Crop> crops = getCropsInCurrentFortnight();
    List<String> names = [];
    List<String> tasks = [];
    for (Crop crop in crops) {
      names.add(crop.cropName);
      tasks.add(_getInSeasonTaskName(crop));
    }
    await LGService.instance.visualizePendingTasks(names, tasks);
  }
}
