import 'package:flutter/material.dart';
import 'package:org_roam/note_storage.dart';
import 'package:org_roam/pages/home.dart';

void main() {
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
      home: MyHomePage(title: 'Org Roam Mobile', storage: NoteStorage()),
    );
  }
}
