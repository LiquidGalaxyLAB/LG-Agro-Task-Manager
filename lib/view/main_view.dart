import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../view_models/main_view_model.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final MainViewModel viewModel = MainViewModel();

  @override
  Widget build(BuildContext context) {
    Color myGreen = const Color(0xFF3E9671);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double buttonSize = screenWidth * 0.12;
    double logoSize = screenWidth * 0.2;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Center(
                  child: Image.asset(
                    'resources/images/logo.png',
                    width: logoSize,
                    height: buttonSize,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                _buildCategoryRow(screenWidth, screenHeight, context),
                SizedBox(height: screenHeight * 0.05),
                _buildSectionHeader('Plants in season:', myGreen),
                const SizedBox(height: 10),
                _buildPlantsInSeasonList(screenWidth, screenHeight, myGreen),
                SizedBox(height: screenHeight * 0.03),
                _buildSendTasksButton(screenWidth, myGreen),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.power_settings_new, color: Colors.red),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(
      double screenWidth, double screenHeight, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCategoryItem(
          context,
          '/crop_page',
          'Crops',
          'resources/images/crops.jpg',
          screenWidth,
          screenHeight,
        ),
        _buildCategoryItem(
          context,
          '/robot_page',
          'Robots',
          'resources/images/robots.png',
          screenWidth,
          screenHeight,
        ),
        _buildCategoryItem(
          context,
          '/settings_page',
          'Settings',
          'resources/images/settings.jpg',
          screenWidth,
          screenHeight,
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    String route,
    String title,
    String imagePath,
    double screenWidth,
    double screenHeight,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Stack(
        children: [
          Container(
            width: screenWidth / 3,
            height: screenHeight / 4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          Container(
            width: screenWidth / 3,
            height: screenHeight / 4,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color myGreen) {
    return Text(
      title,
      style: TextStyle(
        color: myGreen,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPlantsInSeasonList(
      double screenWidth, double screenHeight, Color myGreen) {
    return Container(
      width: screenWidth * 0.8,
      height: screenHeight * 0.2,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: myGreen),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: viewModel.getCropsInCurrentFortnight().length,
        itemBuilder: (context, index) {
          final crop = viewModel.getCropsInCurrentFortnight()[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
            child: ListTile(
              title: Text(
                crop.cropName,
                style: TextStyle(color: myGreen),
              ),
              subtitle: Text(
                viewModel.getTaskText(crop),
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSendTasksButton(double screenWidth, Color myGreen) {
    return ElevatedButton(
      onPressed: () async => await viewModel.sendPendingTasks(),
      style: ElevatedButton.styleFrom(
        backgroundColor: myGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: Size(screenWidth * 0.12, screenWidth * 0.05),
      ),
      child: const Text(
        'Visualize plants in season',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
