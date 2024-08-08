import 'dart:io';

import 'package:flutter/material.dart';
import 'package:org_flutter/org_flutter.dart';
import 'package:org_roam/note_storage.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.storage});

  final String title;
  final NoteStorage storage;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  OrgDocument root = OrgDocument.parse('Loading notes');

  List<FileSystemEntity> notes = [];

  @override
  void initState() {
    widget.storage.listNotes().then((value) {
      widget.storage.readNote(value[0]).then((note) {
        setState(() {
          notes = value;
          root = OrgDocument.parse(note);
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
            const DrawerHeader(
              child: Text('Notes'),
            ),
            for (var note in notes)
              ListTile(
                title: Text(note.path.split('/').last.split('-').last),
                onTap: () {
                  widget.storage.readNote(note).then((value) {
                    setState(() {
                      root = OrgDocument.parse(value);
                    });
                  });
                },
              )
          ]),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                  child: OrgController(
                root: root,
                child: ListView(
                  children: [
                    OrgRootWidget(
                        child: OrgDocumentWidget(root!, shrinkWrap: true)),
                  ],
                ),
              )),
            ],
          ),
        ),
        floatingActionButton: const FloatingActionButton(
          onPressed: null,
          tooltip: 'New Note',
          child: Icon(Icons.add),
        ));
  }
}
