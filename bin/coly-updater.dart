import 'dart:io';
import 'package:http/http.dart';

void main(List<String> args) async {
  String scriptFolderPath;
  try {
    if (Platform.isWindows) {
      scriptFolderPath = Platform.resolvedExecutable.replaceAll("coly-updater.exe", '');
    } else {
      scriptFolderPath = Platform.resolvedExecutable.replaceAll("coly-updater", '');
    }
  } catch (e) {
    print("[ERROR] Could not find Coly :(");
    exit(1);
  }
  var link =
      "https://raw.githubusercontent.com/AaronMarcusDev/Coly/main/updater-builds/windows/coly.exe";

  print("[INFOR] Fetching Coly from: $link");

  Response response;

  try {
    response = await get(Uri.parse(link));
  } catch (e) {
    print("ERROR: Could not fetch Coly.");
    exit(1);
  }

  File file;
  try {
    if (Platform.isWindows) {
      var colyExe = File("$scriptFolderPath\\coly.exe");
      if (await colyExe.exists()) {
        await colyExe.delete();
      }
      file = colyExe;
    } else {
      var coly = File("$scriptFolderPath\\coly");
      if (await coly.exists()) {
        await coly.delete();
      }
      file = coly;
    }
    await file.writeAsBytes(response.bodyBytes);
  } catch (e) {
    print("[ERROR] Could not replace Coly: ${e.toString()}");
    exit(1);
  }

  print("[INFOR] Done!");
}
