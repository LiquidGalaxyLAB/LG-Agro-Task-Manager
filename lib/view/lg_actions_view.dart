import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import '../services/lg_service.dart';
import 'connection_page_view.dart';

class LGActionsView extends StatefulWidget {
  const LGActionsView({super.key});

  @override
  State<LGActionsView> createState() => _LGActionsViewState();
}

class _LGActionsViewState extends State<LGActionsView> {
  LGService lg = LGService(
      ip: '192.168.10.217',
      port: 22,
      username: 'lg',
      password: 'lg',
      screensNum: 5);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color myGreen = const Color(0xFF3E9671);

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: const Text('Liquid Galaxy Actions', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      await lg.connectToLG();
                      await lg.relaunch();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myGreen,
                      fixedSize: const Size(200, 50),
                    ),
                    child: const Text('Reboot LG', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await lg.connectToLG();
                      await lg.cleanKML();
                      await lg.cleanSlaves();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myGreen,
                      fixedSize: const Size(200, 50),
                    ),
                    child: const Text('Clear info', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      await lg.connectToLG();
                      await lg.startOrbit();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myGreen,
                      fixedSize: const Size(200, 50),
                    ),
                    child: const Text('Orbit around position', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await lg.connectToLG();
                      await lg.cleanKML();
                      await lg.cleanSlaves();
                      await lg.setLogos();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myGreen,
                      fixedSize: const Size(200, 50),
                    ),
                    child: const Text('Print info', style: TextStyle(color: Colors.white)),
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
