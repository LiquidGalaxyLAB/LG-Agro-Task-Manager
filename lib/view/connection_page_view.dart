import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/connection_flag.dart';
import '../services/lg_service.dart';
import '../utils/logger.dart';

class ConnectionPageView extends StatefulWidget {
  const ConnectionPageView({super.key});

  @override
  State<ConnectionPageView> createState() => _ConnectionPageView();
}

class _ConnectionPageView extends State<ConnectionPageView> {
  bool connectionStatus = false;

  final Color customGreen = const Color(0xFF3E9671);
  final Color customDarkGrey = const Color(0xFF333333);

  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _sshPortController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _ipController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _sshPortController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _ipController.text = prefs.getString('ipAddress') ?? '';
      _usernameController.text = prefs.getString('username') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _sshPortController.text = prefs.getString('sshPort') ?? '';
    });
    final port = _sshPortController.text.isEmpty
        ? 0
        : int.parse(_sshPortController.text);
    LGService.initialize(
      ip: _ipController.text,
      port: port,
      username: _usernameController.text,
      password: _passwordController.text,
      screensNum: 5,
    );
  }

  Future<void> _saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_ipController.text.isNotEmpty) {
      await prefs.setString('ipAddress', _ipController.text);
    }
    if (_usernameController.text.isNotEmpty) {
      await prefs.setString('username', _usernameController.text);
    }
    if (_passwordController.text.isNotEmpty) {
      await prefs.setString('password', _passwordController.text);
    }
    if (_sshPortController.text.isNotEmpty) {
      await prefs.setString('sshPort', _sshPortController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customDarkGrey,
      appBar: AppBar(
        backgroundColor: customGreen,
        title: const Text('Connection Settings',
            style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ConnectionFlag(status: connectionStatus),
              ),
            ),
            TextField(
              controller: _ipController,
              style: TextStyle(color: customGreen),
              decoration: InputDecoration(
                labelText: 'IP address',
                labelStyle: TextStyle(color: customGreen),
                hintText: 'Enter Master IP',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: customGreen),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: customGreen),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              keyboardType: TextInputType.text,
              style: TextStyle(color: customGreen),
              decoration: InputDecoration(
                labelText: 'LG Username',
                labelStyle: TextStyle(color: customGreen),
                hintText: 'LG username',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: customGreen),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: customGreen),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              style: TextStyle(color: customGreen),
              decoration: InputDecoration(
                labelText: 'LG Password',
                labelStyle: TextStyle(color: customGreen),
                hintText: 'Enter LG password',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: customGreen),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: customGreen),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _sshPortController,
              style: TextStyle(color: customGreen),
              decoration: InputDecoration(
                labelText: 'SSH Port',
                labelStyle: TextStyle(color: customGreen),
                hintText: '22',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: customGreen),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: customGreen),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(customGreen),
                shape: WidgetStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
              ),
              onPressed: () async {
                await _saveSettings();
                await _loadSettings();
                bool result = await LGService.instance.connectToLG();
                setState(() {
                  connectionStatus = result;
                });
                LGService.instance.setLogos();
                if (connectionStatus) {
                  Logger.printInDebug('Connected to LG successfully');
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cast, color: Colors.white),
                      SizedBox(width: 20),
                      Text(
                        'CONNECT TO LG',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(customGreen),
                shape: WidgetStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/lg_actions');
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      Text(
                        'TAKE LG ACTIONS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
