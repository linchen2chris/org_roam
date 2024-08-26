import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';

class NoteStorage {
  Future<String> get _localPath async {
    if (Platform.isAndroid) {
      final directory = await ExternalPath.getExternalStorageDirectories();
      // ignore: avoid_print
      print(directory);

      return directory[0];
    } else if (Platform.isIOS) {
      final download = await getDownloadsDirectory();
      // ignore: avoid_print
      print('path is $download');
      return download!.path;
    }
    return '';
  }

  Future<File> _captureForToday() async {
    final path = await _localPath;
    final todayString = DateTime.now().toString().split(' ')[0];
    final file = File(
        '$path/Download/my-hugo-blog/content/org-roam-notes/daily/$todayString.org');

    // Check if the file exists, and create it if it doesn't.
    if (!await file.exists()) {
      await file.create(recursive: true);
    }

    return file;
  }

  Future<String> readToday() async {
    final file = await _captureForToday();
    return file.readAsString();
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

  Future<File> captureNote(String note) async {
    final file = await _captureForToday();
    return file.writeAsString(note);
  }

  Future<File> editNote(FileSystemEntity note, String content) async {
    final file = File(note.path);
    return file.writeAsString(content);
  }

  Future<List<FileSystemEntity>> listNotes() async {
    final path = await _localPath;
    final directory =
        Directory('$path/Download/my-hugo-blog/content/org-roam-notes');
    final files = await directory
        .list(recursive: true)
        .where((FileSystemEntity f) => f.path.endsWith('org'))
        .toList();
    return files;
  }
}
