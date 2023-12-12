import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:remake_simple_app/db/registration_data.dart';

class RegistrationFile {
  static Future<File> get _localFile async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;

    if (!(await directory.exists())) {
      await directory.create(recursive: true);
    }

    return File('$path//registration.json');
  }

  static Future<RegistrationData?> readRegistrationData() async {
    try {
      final File file = await _localFile;

      if (await file.exists()) {
        final String contents = await file.readAsString();

        final Map<String, dynamic> map = jsonDecode(contents);
        return RegistrationData.fromMap(map);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static writeRegistrationData(RegistrationData registrationData) {
    return _localFile.then((File file) {
      return file.writeAsString(jsonEncode(registrationData.toMap()));
    });
  }
}
