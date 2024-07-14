import 'package:flutter/material.dart';

import '../services/lg_service.dart';

class LGActionsView extends StatefulWidget {
  const LGActionsView({super.key});

  @override
  State<LGActionsView> createState() => _LGActionsViewState();
}

class _LGActionsViewState extends State<LGActionsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color customGreen = const Color(0xFF3E9671);
    final Color customDarkGrey = const Color(0xFF333333);

    final double buttonWidth = MediaQuery.of(context).size.width / 4;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: customDarkGrey,
        appBar: AppBar(
          backgroundColor: customGreen,
          title: const Text('Liquid Galaxy Actions',
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildActionButton(
                  context: context,
                  label: 'Reboot LG',
                  onPressed: () async {
                    await LGService.instance.connectToLG();
                    await LGService.instance.relaunch();
                  },
                  width: buttonWidth,
                ),
                const SizedBox(height: 20),
                _buildActionButton(
                  context: context,
                  label: 'Clear info',
                  onPressed: () async {
                    await LGService.instance.connectToLG();
                    await LGService.instance.cleanKML();
                    await LGService.instance.cleanSlaves();
                  },
                  width: buttonWidth,
                ),
                const SizedBox(height: 20),
                _buildActionButton(
                  context: context,
                  label: 'Orbit around position',
                  onPressed: () async {
                    await LGService.instance.connectToLG();
                    await LGService.instance.startOrbit();
                  },
                  width: buttonWidth,
                ),
                const SizedBox(height: 20),
                _buildActionButton(
                  context: context,
                  label: 'Print info',
                  onPressed: () async {
                    await LGService.instance.connectToLG();
                    await LGService.instance.cleanKML();
                    await LGService.instance.cleanSlaves();
                    await LGService.instance.setLogos();
                  },
                  width: buttonWidth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
    required double width,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3E9671),
        padding: const EdgeInsets.symmetric(vertical: 15),
        fixedSize: Size(width, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
