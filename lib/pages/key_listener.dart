import 'dart:async';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// [KeyListener] listens to the ctrl+y key
/// event and opens the dev tools.
class KeyListener extends StatefulWidget {
  /// Creates a [KeyListener] instance.
  const KeyListener(
      {required this.child, required this.save, required this.insert, Key? key})
      : super(key: key);

  /// The [child] widget.
  final Widget child;

  final Function save;

  final Function insert;

  @override
  State<KeyListener> createState() => _KeyListenerState();
}

class _KeyListenerState extends State<KeyListener> {
  final FocusNode _pageNode = FocusNode();
  Timer? _debounce;
  @override
  Widget build(BuildContext context) => KeyboardListener(
        onKeyEvent: (keyEvent) {
          if (keyEvent is KeyRepeatEvent) {
            return;
          }
          if (_debounce?.isActive ?? false) _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 300), () {
            // do something with query
            if (HardwareKeyboard.instance.isControlPressed) {
              switch (keyEvent.logicalKey.keyLabel) {
                case 'B':
                  print('ctrl+b pressed');
                  widget.insert('#+begin_src \n#+end_src\n', position: 11);
                  break;
                case 'S':
                  print('ctrl+s pressed');
                  widget.save();
                  break;
                case 'I':
                  print('ctrl+i pressed');
                  widget.insert(
                      ':PROPERTIES:\n:ID:       ${const Uuid().v1()}\n:END:\n');
                default:
                  break;
              }
            }
          });
        },
        autofocus: true,
        focusNode: _pageNode,
        child: widget.child,
      );
}
