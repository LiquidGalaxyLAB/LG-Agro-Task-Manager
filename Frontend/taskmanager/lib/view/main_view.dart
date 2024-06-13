import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color myGreen = Color(0xFF3E9671);

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[900], // Canvia el color de fons a gris fosc
        appBar: AppBar(
          backgroundColor: Colors.grey[900], // Canvia el color de la barra d'aplicacions a gris fosc
          title: const Text('Agro Task Manager', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.power_settings_new, color: Colors.red),
              onPressed: () {
                // Defineix l'acció del botó d'apagar aquí
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                child: Container(
                  width: 250,
                  height: 250,
                  color: Colors.grey[900],
                  child: Center(
                      child: Image.asset('resources/logo.png')),
                ),
              ),
              SizedBox(height: 50),
              Container(
                width: 200,
                height: 100,
                color: myGreen,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: myGreen, // Canvia el color del text
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/robot_page');
                  },
                  child: const Text("Robots' tasks"),
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 200,
                    height: 100,
                    color: myGreen,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black, backgroundColor: myGreen, // Canvia el color del text
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/crop_page');
                      },
                      child: const Text('Crops & Calendar'),
                    ),
                  ),
                  SizedBox(width: 50),
                  Container(
                    width: 200,
                    height: 100,
                    color: myGreen,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black, backgroundColor: myGreen, // Canvia el color del text
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings_page');
                      },
                      child: const Text('Settings'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
