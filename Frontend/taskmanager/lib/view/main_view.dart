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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Prova'),
        ),
        body: Row(
          children: [
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/robot_page');
                        },
                        child: const Text('Gestiona els robots'),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/crop_page');
                        },
                        child: const Text('Gestiona els conreus'),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 4,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
