import 'dart:io';

import 'package:path/path.dart' show dirname;
import 'package:flutter/material.dart';
import 'package:org_flutter/org_flutter.dart';
import 'package:org_roam/note_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.storage});

  final String title;
  final NoteStorage storage;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  OrgTree root = OrgDocument.parse('Loading notes');

  List<FileSystemEntity> notes = [];
  List<FileSystemEntity> filteredNotes = [];

  String path = '';

  int selectedNote = 0;

  void search(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredNotes = notes;
      });
      return;
    }
    setState(
      () {
        filteredNotes = notes
            .where(
                (item) => item.path.toLowerCase().contains(query.toLowerCase()))
            .toList();
      },
    );
  }

  @override
  void initState() {
    widget.storage.listNotes().then((List<FileSystemEntity> value) {
      value.sort(
          (b, a) => a.path.split('/').last.compareTo(b.path.split('/').last));
      widget.storage.readNote(value[selectedNote]).then((note) {
        setState(() {
          notes = value;
          filteredNotes = value;
          path = dirname(value[selectedNote].path);
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
          child: ListView(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
              children: [
                DrawerHeader(
                  child: Column(
                    children: [
                      TextField(
                        autofocus: true,
                        onChanged: (value) {
                          search(value);
                        },
                        onSubmitted: (_) {
                          widget.storage
                              .readNote(filteredNotes[0])
                              .then((value) {
                            setState(() {
                              root = OrgDocument.parse(value);
                              path = dirname(filteredNotes[0].path);
                            });
                            Navigator.pop(context);
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: Icon(
                            Icons.search,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                for (final (index, note) in filteredNotes.indexed)
                  ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 0.0),
                    selected: index == selectedNote,
                    minTileHeight: 4.0,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    selectedTileColor: Theme.of(context).focusColor,
                    title: Text(note.path.split('/').last),
                    onTap: () {
                      widget.storage.readNote(note).then((value) {
                        setState(() {
                          selectedNote = index;
                          root = OrgDocument.parse(value);
                          path = dirname(note.path);
                        });
                        Navigator.pop(context);
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
                        child: root is OrgDocument
                            ? OrgDocumentWidget(root as OrgDocument,
                                shrinkWrap: true)
                            : OrgSectionWidget(root as OrgSection,
                                shrinkWrap: true),
                        onLinkTap: (OrgLink link) {
                          print('Link tapped: ${link.location},');
                          launchUrl(Uri.parse(link.location));
                        },
                        onLocalSectionLinkTap: (OrgSection section) {
                          print('section tapped: $section');
                          setState(() {
                            print('root changed to section');
                            root = section;
                          });
                        },
                        loadImage: (OrgLink link) {
                          return Image.file(
                              File('$path/${link.location.split(":").last}'));
                        }),
                  ],
                ),
              )),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/new'),
          tooltip: 'New Note',
          child: const Icon(Icons.add),
        ));
  }
}
