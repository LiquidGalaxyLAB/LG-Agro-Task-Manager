import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taskmanager/view_models/maps_view_model.dart';

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
  final MapsViewModel viewModel = MapsViewModel();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _center = viewModel.decideCoords(widget.field);
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
          zoom: 16.0,
        ),
      ),
    );
  }
}
