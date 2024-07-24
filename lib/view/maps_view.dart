import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsView extends StatefulWidget {
  final String field;

  const MapsView({super.key, required this.field});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  static const Color customGreen = Color(0xFF3E9671);
  static const Color customDarkGrey = Color(0xFF333333);
  late GoogleMapController mapController;
  late LatLng _center;
  late String field;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  LatLng decideCoords() {
    field = widget.field;
    switch (field) {
      case 'Seròs 1':
        return const LatLng(41.46418749774492, 0.3979543781084849);
      case 'Seròs 2':
        return const LatLng(41.47251603794711, 0.4084249020488806);
      default:
        return const LatLng(41.46418749774492, 0.3979543781084849);
    }
  }

  @override
  void initState() {
    super.initState();
    _center = decideCoords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customDarkGrey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Maps view'),
        backgroundColor: customGreen,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }
}
