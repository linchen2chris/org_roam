import 'package:flutter/material.dart';
import 'package:org_roam/note_storage.dart';
import 'package:org_roam/pages/key_listener.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key, required this.title, required this.storage});

  final String title;
  final NoteStorage storage;

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final TextEditingController _noteController = TextEditingController();

  final todayString = DateTime.now().toString().split(' ')[0];
  @override
  void initState() {
    widget.storage.readToday().then((note) {
      _noteController.text = note;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('${widget.title} for $todayString.org'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: KeyListener(
                  insert: (String block, {int position = 0}) {
                    _noteController.text += block;
                    _noteController.selection = TextSelection.fromPosition(
                        TextPosition(
                            offset: _noteController.text.length - position));
                  },
                  save: () {
                    widget.storage
                        .captureNote(_noteController.text)
                        .then((value) {
                      Navigator.pop(context);
                    });
                  },
                  child: TextField(
                    maxLines: null,
                    minLines: 20,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Notes',
                    ),
                    controller: _noteController,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              _noteController.text += '\n* ';
            },
            child: const Text('*'),
          ),
          ElevatedButton(
            onPressed: () {
              _noteController.text += '\n** ';
            },
            child: const Text('**'),
          ),
          ElevatedButton(
            onPressed: () {
              _noteController.text += '\n*** ';
            },
            child: const Text('***'),
          ),
          ElevatedButton(
              onPressed: () {
                _noteController.text += '#+begin_src \n#+end_src\n';
                _noteController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _noteController.text.length - 12));
              },
              child: const Text('src')),
          ElevatedButton(
            onPressed: () {
              widget.storage.captureNote(_noteController.text).then((value) {
                Navigator.pop(context);
              });
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
