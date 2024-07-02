import 'package:flutter/material.dart';
import 'package:taskmanager/services/database_service.dart';

import '../view_models/main_view_model.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final MainViewModel viewModel = MainViewModel();

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await DataBaseService.getInstance();
    viewModel.fetchCrops();
  }

  @override
  Widget build(BuildContext context) {
    Color myGreen = const Color(0xFF3E9671);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double buttonSize = screenWidth * 0.15;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: const Text('Agro Task Manager', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.power_settings_new, color: Colors.red),
              onPressed: () {
                // Add your logout logic here
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset('resources/logo.png', width: buttonSize, height: buttonSize),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: buttonSize,
                    height: buttonSize,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: myGreen,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/crop_page');
                      },
                      child: const Text('Crops & Calendar'),
                    ),
                  ),
                  SizedBox(
                    width: buttonSize,
                    height: buttonSize,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: myGreen,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/robot_page');
                      },
                      child: const Text("Robots' tasks"),
                    ),
                  ),
                  SizedBox(
                    width: buttonSize,
                    height: buttonSize,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: myGreen,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings_page');
                      },
                      child: const Text('Settings'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 150),
              const Text(
                'Plants in season:',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Container(
                width: screenWidth * 0.8,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.white),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: viewModel.cropsInCurrentFortnight.length,
                  itemBuilder: (context, index) {
                    final crop = viewModel.cropsInCurrentFortnight[index];
                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white, width: 0.5),
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          crop.cropName,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          viewModel.getTaskText(crop),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
