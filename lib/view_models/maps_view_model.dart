import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsViewModel {
  LatLng decideCoords(String field) {
    switch (field) {
      case 'Seròs 1':
        return const LatLng(41.46418749774492, 0.3979543781084849);
      case 'Seròs 2':
        return const LatLng(41.47251603794711, 0.4084249020488806);
      case 'Seròs 3':
        return const LatLng(41.45576266074729, 0.4109749853423694);
      case 'Anaquela del Ducado 1':
        return const LatLng(40.96905918864691, -2.145975223287178);
      case 'Anaquela del Ducado 2':
        return const LatLng(40.97974878207128, -2.126119001309186);
      case 'Anaquela del Ducado 3':
        return const LatLng(40.96941290339948, -2.130425272682435);
      case 'Soria 1':
        return const LatLng(41.78944953901075, -2.505413902380553);
      case 'Soria 2':
        return const LatLng(41.78750100401503, -2.440841857584821);
      case 'Soria 3':
        return const LatLng(41.75753039698073, -2.495039423247405);
      case 'Rajauya 1':
        return const LatLng(23.80259611860802, 78.70582558141308);
      case 'Rajauya 2':
        return const LatLng(23.80655804252958, 78.69498072398927);
      case 'Rajauya 3':
        return const LatLng(23.81043484664496, 78.70158580955184);
      case 'Nagjhiri 1':
        return const LatLng(21.78231355872353, 75.68542059625399);
      case 'Nagjhiri 2':
        return const LatLng(21.79059738682185, 75.69503219286756);
      case 'Nagjhiri 3':
        return const LatLng(21.77934280643524, 75.67207194614996);
      case 'Karur 1':
        return const LatLng(15.43867103521269, 76.95483367728106);
      case 'Karur 2':
        return const LatLng(15.4413892799804, 76.94021647003702);
      case 'Karur 3':
        return const LatLng(15.43157685157439, 76.94286473949052);
      default:
        return const LatLng(41.46418749774492, 0.3979543781084849);
    }
  }
}
