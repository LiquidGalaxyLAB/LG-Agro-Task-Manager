import 'package:flutter/material.dart';

class MapsView extends StatefulWidget {
  const MapsView({super.key});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  static const Color customGreen = Color(0xFF3E9671);
  static const Color customDarkGrey = Color(0xFF333333);
  static const Color customLightGrey = Color(0xFF4F4F4F);

  //TODO: apply google maps UI in this whole view
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
      body: const Column(
        children: [],
      ),
    );
  }
}
