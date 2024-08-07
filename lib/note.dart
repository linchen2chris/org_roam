import 'package:flutter/material.dart';
import 'package:org_flutter/org_flutter.dart';

class Note extends StatelessWidget {
  const Note({super.key, required String content}) : _content = content;

  final String _content;
  @override
  Widget build(BuildContext context) {
    return Org(_content);
  }
}
