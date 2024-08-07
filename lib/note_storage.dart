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

  Future<String> readNote(FileSystemEntity note) async {
    try {
      final file = File(note.path);
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

  Future<List<FileSystemEntity>> listNotes() async {
    final path = await _localPath;
    final directory = Directory('$path/OrgRoams');
    final files = await directory.list().toList();
    return files;
  }
}
