import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';

class NoteStorage {
  Future<String> get _localPath async {
    if (Platform.isAndroid) {
      final directory = await ExternalPath.getExternalStorageDirectories();
      // ignore: avoid_print
      print(directory);

      return directory[1];
    } else if (Platform.isIOS) {
      final download = await getDownloadsDirectory();
      // ignore: avoid_print
      print('path is $download');
      return download!.path;
    }
    return '';
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/OrgRoams/inbox.org');
  }

  Future<String> readNote(FileSystemEntity note) async {
    try {
      final file = File(note.path);
      final contents = await file.readAsString();
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
    final files = await directory
        .list(recursive: true)
        .where((FileSystemEntity f) => f.path.endsWith('org'))
        .toList();
    return files;
  }
}
