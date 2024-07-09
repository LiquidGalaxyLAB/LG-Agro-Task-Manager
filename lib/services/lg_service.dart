import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:xml/xml.dart' as xml;
import 'look_at_service.dart';
import 'orbit_service.dart';

class LGService {
  SSHClient? _client;
  final spainPath = 'resources/kml/Espanya.kml';
  final indiaPath = 'resources/kml/India.kml';
  late String ip;
  late int port;
  late String username;
  late String password;
  late int screensNum;
  bool connected = false;

  static final LGService _instance = LGService._internal();

  LGService();
  LGService._internal();

  static LGService initialize({
    required String ip,
    required int port,
    required String username,
    required String password,
    required int screensNum,
  }) {
    _instance.ip = ip;
    _instance.port = port;
    _instance.username = username;
    _instance.password = password;
    _instance.screensNum = screensNum;
    return _instance;
  }

  static LGService get instance => _instance;

  String extractKmlSection(String kmlContent, String sectionName) {
    final document = xml.XmlDocument.parse(kmlContent);
    final folder = document.findAllElements('Folder').firstWhere(
          (element) => element.findElements('name').any((name) => name.text == sectionName),
    );

    return '<?xml version="1.0" encoding="UTF-8"?>\n<kml xmlns="http://www.opengis.net/kml/2.2">${folder.toXmlString()}</kml>';
  }

  Future<bool> connectToLG() async {
    try {
      final socket = await SSHSocket.connect(ip, port,
          timeout: const Duration(seconds: 10));
      _client = SSHClient(
        socket,
        username: username,
        onPasswordRequest: () => password,
      );
      if (_client != null) {
        connected = true;
        setLogos();
        return true;
      }
    } catch (e) {
      print("Connection error: $e");
      connected = false;
      return false;
    }
    return false;
  }

  Future<void> displaySpecificKML(String name, String country) async {
    String filePath = "none";
    if(country == "India") {
      filePath = indiaPath;
    } else if (country == "Espanya") {
      filePath = spainPath;
    }
    try {
      final kmlContent = await rootBundle.loadString(filePath);
      final kmlSection = extractKmlSection(kmlContent, name);
      final localFile = await makeFile(name, kmlSection);

      await printKMLFileContent(name.replaceAll(' ', '_'));

      await uploadKMLFile(localFile, name.replaceAll(' ', '_'), "Task_Balloon");

      final coordinates = extractCoordinates(kmlSection);
      if (coordinates != null) {
        await goToCoordinates(coordinates[0], coordinates[1]);
      } else {
        print("No coordinates");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<double>? extractCoordinates(String kmlContent) {
    try {
      final document = xml.XmlDocument.parse(kmlContent);
      final coordinatesElement = document.findAllElements('coordinates').first;
      final coordinatesText = coordinatesElement.text.trim();
      final coordinatesParts = coordinatesText.split(',');

      final longitude = double.parse(coordinatesParts[0]);
      final latitude = double.parse(coordinatesParts[1]);

      return [latitude, longitude];
    } catch (e) {
      print("Error at extractCoord: $e");
      return null;
    }
  }

  Future<SSHSession?> relaunch() async {
    try {
      if (_client == null) {
        print("Error, the client is not initialized");
        return null;
      }
      for (int i = 5; i > 0; i--) {
        await _client!.execute(
            'sshpass -p $password ssh -t lg$i "echo $password | sudo -S reboot" ');
        print(
            'sshpass -p $password ssh -t lg$i "echo $password | sudo -S reboot"');
      }
    } catch (e) {
      print("An error has occured: $e");
      return null;
    }
    return null;
  }

  Future<File?> makeFile(String filename, String content) async {
    try {
      var localPath = await getApplicationDocumentsDirectory();
      String sanitizedFilename = filename.replaceAll(' ', '_');
      File localFile = File('${localPath.path}/$sanitizedFilename.kml');
      await localFile.writeAsString(content);
      return localFile;
    } catch (e) {
      print("Error creating file: $e");
      return null;
    }
  }



  String orbitLookAtLinear(double latitude, double longitude, double zoom,
      double tilt, double bearing) {
    return '<gx:duration>1.2</gx:duration><gx:flyToMode>smooth</gx:flyToMode><LookAt><longitude>$longitude</longitude><latitude>$latitude</latitude><range>$zoom</range><tilt>$tilt</tilt><heading>$bearing</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';
  }

  Future<SSHSession?> flyToOrbit(double latitude, double longitude, double zoom,
      double tilt, double bearing) async {
    try {
      if (_client == null) {
        print('MESSAGE :: SSH CLIENT IS NOT INITIALISED');
        return null;
      }

      final executeResult = await _client!.execute(
          'echo "flytoview=${orbitLookAtLinear(latitude, longitude, zoom, tilt, bearing)}" > /tmp/query.txt');
      print(executeResult);
      return executeResult;
    } catch (e) {
      print('MESSAGE :: AN ERROR HAS OCCURRED WHILE EXECUTING THE COMMAND: $e');
      return null;
    }
  }

  Future<void> printKMLFileContent(String filename) async {
    try {
      var localPath = await getApplicationDocumentsDirectory();
      File localFile = File('${localPath.path}/$filename.kml');
      if (await localFile.exists()) {
        String fileContent = await localFile.readAsString();
        print("Content of $filename.kml:");
        print(fileContent);
      } else {
        print("File $filename.kml does not exist.");
      }
    } catch (e) {
      print("Error reading file: $e");
    }
  }

  Future<void> beginOrbiting() async {
    try {
      await _client!.run('echo "playtour=Orbit" > /tmp/query.txt');
      print("Orbiting started");
    } catch (error) {
      print("Error starting orbit: $error");
      await beginOrbiting();
    }
  }

  Future<void> uploadKMLFile(File? inputFile, String kmlName, String task) async {
    if (inputFile == null) {
      print("Input file is null");
      return;
    }
    try {
      await connectToLG();
      cleanKML();
      cleanSlaves();

      final sftp = await _client!.sftp();
      final file = await sftp.open('/var/www/html/$kmlName.kml',
          mode: SftpFileOpenMode.create |
          SftpFileOpenMode.truncate |
          SftpFileOpenMode.write);

      var bytes = await inputFile.readAsBytes();

      file.writeBytes(bytes);

      await _client!.execute(
          "echo 'http://lg1:81/$kmlName.kml' > /var/www/html/kmls.txt");
    } catch (e) {
      print("Error uploading file: $e");
    }
  }


  Future<SSHSession?> goToCoordinates(double latitude, double longitude) async {
    try {
      if (_client == null) {
        print("Error, the client is not initialized");
        return null;
      }

      final command = 'echo "flytoview=<LookAt>'
          '<longitude>$longitude</longitude>'
          '<latitude>$latitude</latitude>'
          '<altitude>0</altitude>'
          '<heading>0</heading>'
          '<tilt>0</tilt>'
          '<range>1500</range>'
          '<gx:altitudeMode>relativeToGround</gx:altitudeMode>'
          '</LookAt>" >/tmp/query.txt';

      final session = await _client!.execute(command);
      return session;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }




  Future<void> orbitAtMyCity() async {
    try {
      if (_client == null) {
        print('MESSAGE :: SSH CLIENT IS NOT INITIALISED');
        return;
      }

      await cleanKML();

      String orbitKML = OrbitEntity.buildOrbit(OrbitEntity.tag(LookAtEntity(
          lng: 2.287730, lat: 41.607970, range: 7000, tilt: 60, heading: 0)));

      File? inputFile = await makeFile("OrbitKML", orbitKML);
      await uploadKMLFile(inputFile, "OrbitKML", "Task_Orbit");
    } catch (e) {
      print("Error");
    }
  }

  Future<void> setLogos() async {
    int infoSlave;
    if (screensNum == 3) {
      infoSlave = 2;
    } else {
      infoSlave = 4;
    }
    try {
      String imagePath = 'resources/images/logosLG.png';

      ByteData imageData = await rootBundle.load(imagePath);
      Uint8List imageBytes = imageData.buffer.asUint8List();
      String imageBase64 = base64Encode(imageBytes);

      /*String kmlContent = """<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">
  <GroundOverlay>
    <name>LogoOverlay</name>
    <Icon>
      <href>data:image/png;base64,$imageBase64</href>
    </Icon>
    <LatLonBox>
      <north>28.638478</north>
      <south>28.637978</south>
      <east>-17.841286</east>
      <west>-17.841786</west>
    </LatLonBox>
  </GroundOverlay>
</kml>""";
      String command = """echo '$kmlContent' > /var/www/html/kml/slave_$infoSlave.kml""";*/
      
      await _client?.execute("""chmod 777 /var/www/html/kml/slave_$infoSlave.kml; echo '<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">
  <GroundOverlay>
    <name>LogoOverlay</name>
    <Icon>
      <href>data:image/png;base64,$imageBase64</href>
    </Icon>
    <LatLonBox>
      <north>28.638478</north>
      <south>28.637978</south>
      <east>-17.841286</east>
      <west>-17.841786</west>
    </LatLonBox>
  </GroundOverlay>
</kml>
' > /var/www/html/kml/slave_$infoSlave.kml""");
    } catch (e) {
      print(e);
    }
    print("logos set succesfully");
  }



  stopOrbit() async {
    try {
      await _client!.run('echo "exittour=true" > /tmp/query.txt');
    } catch (error) {
      stopOrbit();
    }
  }

  startOrbit() async {
    try {
      await _client!.run('echo "playtour=Orbit" > /tmp/query.txt');
    } catch (error) {
      stopOrbit();
    }
  }

  cleanSlaves() async {
    try {
      await _client!.run("echo '' > /var/www/html/kml/slave_2.kml");
      await _client!.run("echo '' > /var/www/html/kml/slave_3.kml");
    } catch (error) {
      await cleanSlaves();
    }
  }

  cleanKML() async {
    try {
      await stopOrbit();
      await _client!.run("echo '' > /tmp/query.txt");
      await _client!.run("echo '' > /var/www/html/kmls.txt");
    } catch (error) {
      await cleanKML();
    }
  }
}
