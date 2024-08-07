import 'dart:io';

import 'package:external_path/external_path.dart';

class NoteStorage {
  Future<String> get _localPath async {
    final directory = await ExternalPath.getExternalStorageDirectories();
    print(directory);

    return directory[1];
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/OrgRoams/inbox.org');
  }

  Future<String> readNote() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      print('contents: $contents');
      return contents;
    } catch (e) {
      return '';
    }
  }

  Future<File> writeNote(String note) async {
    final file = await _localFile;
    return file.writeAsString(note);
  }
}
