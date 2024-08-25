import 'dart:async';
import 'dart:io';

import 'package:dartssh4/dartssh4.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart' as xml;
import 'package:xml/xml.dart';

import '../utils/logger.dart';
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
    XmlElement? usedFolder;
    Logger.printInDebug("enro aquí");

    final folders = document.findAllElements('Folder');
    for (var folder in folders) {
      final nameElement = folder.findElements('name').first;
      if (nameElement.value == sectionName) {
        usedFolder = folder;
        break;
      }
    }

    return '<?xml version="1.0" encoding="UTF-8"?>\n<kml xmlns="http://www.opengis.net/kml/2.2">${usedFolder?.toXmlString()}</kml>';
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
        return true;
      }
      setLogos();
    } catch (e) {
      Logger.printInDebug("Connection error: $e");
      connected = false;
      return false;
    }
    return false;
  }

  Future<void> displaySpecificKML(String name, String country) async {
    String filePath = "none";
    if (country == "India") {
      filePath = indiaPath;
    } else if (country == "Espanya") {
      filePath = spainPath;
    }
    try {

      final kmlContent = await rootBundle.loadString(filePath);

      final kmlSection = extractKmlSection(kmlContent, name);
      Logger.printInDebug("excraced");
      final localFile = await makeFile(name, kmlSection);
      Logger.printInDebug("Made");
      await printKMLFileContent(name.replaceAll(' ', '_'));
      await uploadKMLFile(localFile, name.replaceAll(' ', '_'));
      Logger.printInDebug("Uploaded");
      final coordinates = extractCoordinates(kmlSection);
      if (coordinates != null) {
        await goToCoordinates(coordinates[0], coordinates[1]);
      } else {
        Logger.printInDebug("No coordinates");
      }
    } catch (e) {
      Logger.printInDebug('Error: $e');
    }
  }

  List<double>? extractCoordinates(String kmlContent) {
    try {
      final document = xml.XmlDocument.parse(kmlContent);
      final coordinatesElement = document.findAllElements('coordinates').first;
      final coordinatesText = coordinatesElement.value?.trim() ?? "";
      final coordinatesParts = coordinatesText.split(',');

      final longitude = double.parse(coordinatesParts[0]);
      final latitude = double.parse(coordinatesParts[1]);

      return [latitude, longitude];
    } catch (e) {
      Logger.printInDebug("Error at extractCoord: $e");
      return null;
    }
  }

  Future<SSHSession?> relaunch() async {
    try {
      if (_client == null) {
        Logger.printInDebug("Error, the client is not initialized");
        return null;
      }
      for (int i = 5; i > 0; i--) {
        await _client!.execute(
            'sshpass -p $password ssh -t lg$i "echo $password | sudo -S reboot" ');
        Logger.printInDebug(
            'sshpass -p $password ssh -t lg$i "echo $password | sudo -S reboot"');
      }
    } catch (e) {
      Logger.printInDebug("An error has occured: $e");
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
      Logger.printInDebug("Error creating file: $e");
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
        Logger.printInDebug('MESSAGE :: SSH CLIENT IS NOT INITIALISED');
        return null;
      }

      final executeResult = await _client!.execute(
          'echo "flytoview=${orbitLookAtLinear(latitude, longitude, zoom, tilt, bearing)}" > /tmp/query.txt');
      Logger.printInDebug(executeResult);
      return executeResult;
    } catch (e) {
      Logger.printInDebug(
          'MESSAGE :: AN ERROR HAS OCCURRED WHILE EXECUTING THE COMMAND: $e');
      return null;
    }
  }

  Future<void> printKMLFileContent(String filename) async {
    try {
      var localPath = await getApplicationDocumentsDirectory();
      File localFile = File('${localPath.path}/$filename.kml');
      if (await localFile.exists()) {
        String fileContent = await localFile.readAsString();
        Logger.printInDebug("Content of $filename.kml:");
        Logger.printInDebug(fileContent);
      } else {
        Logger.printInDebug("File $filename.kml does not exist.");
      }
    } catch (e) {
      Logger.printInDebug("Error reading file: $e");
    }
  }

  Future<void> beginOrbiting() async {
    try {
      await _client!.run('echo "playtour=Orbit" > /tmp/query.txt');
      Logger.printInDebug("Orbiting started");
    } catch (error) {
      Logger.printInDebug("Error starting orbit: $error");
      await beginOrbiting();
    }
  }

  Future<void> uploadKMLFile(File? inputFile, String kmlName) async {
    if (inputFile == null) {
      Logger.printInDebug("Input file is null");
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
      Logger.printInDebug("Error uploading file: $e");
    }
  }

  Future<void> visualizePendingTasks(List<String> names, List<String> tasks) async {
    if (names.length != tasks.length) {
      throw ArgumentError('Les llistes de noms i tasques han de tenir la mateixa longitud');
    }

    int infoSlave;
    if (screensNum == 1) {
      infoSlave = 1;
    } else {
      infoSlave = (screensNum / 2).floor() + 1;
    }

    String tasksTable = "<table width='400' height='300' align='left'>";
    tasksTable += "<tr><td colspan='2' style='text-align: center;'><h1>Recommended Tasks</h1></td></tr>";

    String escapeXml(String input) {
      return input.replaceAll('&', '&amp;')
          .replaceAll('<', '&lt;')
          .replaceAll('>', '&gt;')
          .replaceAll('"', '&quot;')
          .replaceAll("'", '&apos;');
    }

    for (int i = 0; i < names.length; i++) {
      tasksTable += "<tr><td style='text-align: left;'><h2>${escapeXml(names[i])}</h2></td>";
      tasksTable += "<td style='text-align: right;'><h2>${escapeXml(tasks[i])}</h2></td></tr>";
    }

    tasksTable += "</table>";

    String command = """
  chmod 777 /var/www/html/kml/slave_$infoSlave.kml; echo '<?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
    <Document>
      <name>Recommended_Tasks.kml</name> 
      <Style id="purple_paddle">
        <BalloonStyle>
          <text><![CDATA[$tasksTable]]></text>
          <bgColor>ffffffff</bgColor>
        </BalloonStyle>
      </Style>
      <Placemark id="0A7ACC68BF23CB81B354">
        <name>Balloon</name>
        <Snippet maxLines="0"></Snippet>
        <description><![CDATA[$tasksTable]]></description>
        <LookAt>
          <longitude>-17.841486</longitude>
          <latitude>28.638478</latitude>
          <altitude>0</altitude>
          <heading>0</heading>
          <tilt>0</tilt>
          <range>24000</range>
        </LookAt>
        <styleUrl>#purple_paddle</styleUrl>
        <gx:balloonVisibility>1</gx:balloonVisibility>
        <Point>
          <coordinates>-17.841486,28.638478,0</coordinates>
        </Point>
      </Placemark>
    </Document>
  </kml>
  ' > /var/www/html/kml/slave_$infoSlave.kml""";


    try {
      await _client!.execute(command);
    } catch (e) {
      Logger.printInDebug(e);
    }
  }


  Future<void> sendTaskKML(String robotName, String taskName, String fieldName) async {
    int infoSlave;
    if (screensNum == 1) {
      infoSlave = 1;
    } else {
      infoSlave = (screensNum / 2).floor() + 1;
    }
    try {
      String command =
      """chmod 777 /var/www/html/kml/slave_$infoSlave.kml; echo '<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    <name>historic.kml</name> 
    <Style id="purple_paddle">
      <BalloonStyle>
        <text><![CDATA[
        <table width="400" height="300" align="left">
            <tr>
              <td colspan="2" align="center">
                <h1>Robot name: $robotName</h1> 
              </td>
            </tr>
            <tr>
              <td colspan="2" align="center">
                <h1>Current Task: $taskName</h1>  <h1>Field of action: $fieldName</h1>  </td>
            </tr>
          </table>
        ]]></text>
        <bgColor>ffffffff</bgColor>
      </BalloonStyle>
    </Style>
    <Placemark id="0A7ACC68BF23CB81B354">
      <name>Balloon</name>
      <Snippet maxLines="0"></Snippet>
      <description><![CDATA[
        <table width="400" height="300" align="left">
            <tr>
              <td colspan="2" align="center">
                <h1>$robotName</h1> 
              </td>
            </tr>
            <tr>
              <td colspan="2" align="center">
                <h1>Current Task: $taskName</h1>  <h1>Field of action: $fieldName</h1>  </td>
            </tr>
          </table>
      ]]></description>
      <LookAt>
        <longitude>-17.841486</longitude>
        <latitude>28.638478</latitude>
        <altitude>0</altitude>
        <heading>0</heading>
        <tilt>0</tilt>
        <range>24000</range>
      </LookAt>
      <styleUrl>#purple_paddle</styleUrl>
      <gx:balloonVisibility>1</gx:balloonVisibility>
      <Point>
        <coordinates>-17.841486,28.638478,0</coordinates>
      </Point>
    </Placemark>
  </Document>
</kml>
' > /var/www/html/kml/slave_$infoSlave.kml""";

      await _client!.execute(command);
    } catch (e) {
      Logger.printInDebug(e);
    }
  }

  Future<SSHSession?> goToCoordinates(double latitude, double longitude) async {
    try {
      if (_client == null) {
        Logger.printInDebug("Error, the client is not initialized");
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
      Logger.printInDebug('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<void> orbitAtMyCity() async {
    try {
      if (_client == null) {
        Logger.printInDebug('MESSAGE :: SSH CLIENT IS NOT INITIALISED');
        return;
      }

      await cleanKML();

      String orbitKML = OrbitEntity.buildOrbit(OrbitEntity.tag(LookAtEntity(
          lng: 2.287730, lat: 41.607970, range: 7000, tilt: 60, heading: 0)));

      File? inputFile = await makeFile("OrbitKML", orbitKML);
      await uploadKMLFile(inputFile, "OrbitKML");
    } catch (e) {
      Logger.printInDebug("Error");
    }
  }

  Future<void> setLogos() async {
    try {
      await _client!.execute('''cat > /var/www/html/kml/slave_4.kml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
 <Document>
   <name>Pablo</name>
   <open>1</open>
   <Folder>
     <name>Logos</name>
           <ScreenOverlay>
       <name>LogoSO</name>
       <Icon>
         <href>https://imgur.com/TL3V3pK.jpeg</href>
       </Icon>
       <color>ffffffff</color>
       <overlayXY x="0.0" y="1.0" xunits="fraction" yunits="fraction"/>
       <screenXY x="0.02" y="0.95" xunits="fraction" yunits="fraction"/>
       <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
       <size x="700.0" y="382.0" xunits="pixels" yunits="pixels"/>
     </ScreenOverlay>
  
   </Folder>
 </Document>
</kml>
''');
      Logger.printInDebug("Logos set successfully for slave 4");
    } catch (e) {
      Logger.printInDebug(e);
    }
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
