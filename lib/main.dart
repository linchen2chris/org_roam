import 'package:flutter/material.dart';
import 'package:org_flutter/org_flutter.dart';
import 'package:org_roam/note.dart';
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
  late final OrgDocument root;

  @override
  void initState() {
    widget.storage.readNote().then((value) {
      root = OrgDocument.parse(value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        child: OrgDocumentWidget(root, shrinkWrap: true)),
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
