import 'package:flutter/material.dart';
import 'package:taskmanager/services/database_service.dart';
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
  void initState() {
    super.initState();
    viewModel.initializeDatabase();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Color myGreen = const Color(0xFF3E9671);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double buttonSize = screenWidth * 0.12;
    double logoSize = screenWidth * 0.2;

    return MaterialApp(
      home: Scaffold(
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
                    child: Image.asset('resources/images/logo.png', width: logoSize, height: buttonSize),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/crop_page');
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: screenWidth / 3,
                              height: screenHeight / 4,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('resources/images/crops.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: screenWidth / 3,
                              height: screenHeight / 4,
                              color: Colors.black.withOpacity(0.3),
                              child: Center(
                                child: Text(
                                  'Crops',
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
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/robot_page');
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: screenWidth / 3,
                              height: screenHeight / 4,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('resources/images/robots.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: screenWidth / 3,
                              height: screenHeight / 4,
                              color: Colors.black.withOpacity(0.3),
                              child: Center(
                                child: Text(
                                  'Robots',
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
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/settings_page');
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: screenWidth / 3,
                              height: screenHeight / 4,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('resources/images/settings.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: screenWidth / 3,
                              height: screenHeight / 4,
                              color: Colors.black.withOpacity(0.3),
                              child: Center(
                                child: Text(
                                  'Settings',
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
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Text(
                    'Plants in season:',
                    style: TextStyle(color: myGreen, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.3,
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
                              style: TextStyle(color: myGreen),
                            ),
                            subtitle: Text(
                              viewModel.getTaskText(crop),
                              style: TextStyle(color: myGreen),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
      ),
    );
  }
}
