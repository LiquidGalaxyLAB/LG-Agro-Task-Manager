import 'dart:async';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:path_provider/path_provider.dart';

import 'look_at_service.dart';
import 'orbit_service.dart';

class LGService {
  SSHClient? _client;
  late String ip;
  late int port;
  late String username;
  late String password;
  late int screensNum;
  bool connected = false;

  LGService(
      {required this.ip,
        required this.port,
        required this.username,
        required this.password,
        required this.screensNum});

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
    } catch (e) {
      connected = false;
      return false;
    }
    return false;
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
      print("An error has occured");
      return null;
    }
  }

  Future<SSHSession?> goToGranollers() async {
    try {
      if (_client == null) {
        print("Error, the client is not initialized");
        return null;
      }
      final session =
      await _client!.execute('echo "search=Barcelona" >/tmp/query.txt');
      return session;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  makeFile(String filename, String content) async {
    try {
      var localPath = await getApplicationDocumentsDirectory();
      File localFile = File('${localPath.path}/${filename}.kml');
      await localFile.writeAsString(content);

      return localFile;
    } catch (e) {
      return null;
    }
  }

  loadKML(String kmlName, String task) async {
    try {
      final v = await _client!.execute(
          "echo 'http://lg1:81/$kmlName.kml' > /var/www/html/kmls.txt");

      if (task == "Task_Orbit") {
        await beginOrbiting();
      }
    } catch (error) {
      print("error");
      await loadKML(kmlName, task);
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

  beginOrbiting() async {
    try {
      final res = await _client!.run('echo "playtour=Orbit" > /tmp/query.txt');
    } catch (error) {
      await beginOrbiting();
    }
  }

  uploadKMLFile(File inputFile, String kmlName, String task) async {
    try {
      bool uploading = true;
      final sftp = await _client!.sftp();
      final file = await sftp.open('/var/www/html/$kmlName.kml',
          mode: SftpFileOpenMode.create |
          SftpFileOpenMode.truncate |
          SftpFileOpenMode.write);
      var fileSize = await inputFile.length();
      file.write(inputFile.openRead().cast(), onProgress: (progress) async {
        if (fileSize == progress) {
          uploading = false;
          if (task == "Task_Orbit") {
            await loadKML("OrbitKML", task);
          } else if (task == "Task_Balloon") {
            await loadKML("BalloonKML", task);
          }
        }
      });
    } catch (e) {
      print("Error");
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

      File inputFile = await makeFile("OrbitKML", orbitKML);
      await uploadKMLFile(inputFile, "OrbitKML", "Task_Orbit");
    } catch (e) {
      print("Error");
    }
  }

  Future<void> setLogos() async {
    int infoSlave;
    if (screensNum == 1)
      infoSlave = 1;
    else
      infoSlave = (screensNum / 2).floor() + 1;
    try {
      String command =
      """chmod 777 /var/www/html/kml/slave_$infoSlave.kml; echo '<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    <name>historic.kml</name> 
    <Style id="purple_paddle">
      <BalloonStyle>
        <text>\$[description]</text>
        <bgColor>ffffffff</bgColor>
      </BalloonStyle>
    </Style>
    <Placemark id="0A7ACC68BF23CB81B354">
      <name>Baloon</name>
      <Snippet maxLines="0"></Snippet>
      <description>
      <![CDATA[<!-- BalloonStyle background color: ffffffff -->
        <table width="400" height="300" align="left">
          <tr>
            <td colspan="2" align="center">
              <h1>David Mas</h1>
              <h2> Universitat de Lleida (UdL)</h2>
            </td>
          </tr>
          <tr>
            <td colspan="2" align="center">
              <h1>Granollers, Catalonia, Spain</h1>
            </td>
          </tr>
        </table>]]>
      </description>
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
      print(e);
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
