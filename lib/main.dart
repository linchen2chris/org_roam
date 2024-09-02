import 'package:flutter/material.dart';
import 'package:org_roam/note_storage.dart';
import 'package:org_roam/pages/camera.dart';
import 'package:org_roam/pages/create_note.dart';
import 'package:org_roam/pages/home.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Org Roam Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0x0063A002),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>
            MyHomePage(title: 'Org Roam Mobile', storage: NoteStorage()),
        '/new': (context) =>
            CreateNotePage(title: 'Create Note', storage: NoteStorage()),
        '/camera': (context) => const TakePictureScreen(),
      },
    );
  }
}
