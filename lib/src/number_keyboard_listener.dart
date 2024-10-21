import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberKeyboardListener {
  NumberKeyboardListener({
    required this.onNumberPressed,
    required this.onDeletePressed,
    required this.onDecimalPressed,
    required this.onClearPressed,
    required this.onEnterPressed,
    this.onPastePressed,
  }) {
    HardwareKeyboard.instance.addHandler(_onKeyEvent);
  }

  final void Function(int number) onNumberPressed;
  final void Function() onDeletePressed;
  final void Function() onDecimalPressed;
  final void Function() onClearPressed;
  final void Function() onEnterPressed;
  final void Function()? onPastePressed;

  bool _onKeyEvent(KeyEvent keyEvent) {
    if (keyEvent is! KeyDownEvent) {
      return false;
    }
    bool isNumPadNumber =
        keyEvent.logicalKey.keyId >= LogicalKeyboardKey.numpad0.keyId &&
            keyEvent.logicalKey.keyId <= LogicalKeyboardKey.numpad9.keyId;
    bool isNumber =
        keyEvent.logicalKey.keyId >= LogicalKeyboardKey.digit0.keyId &&
            keyEvent.logicalKey.keyId <= LogicalKeyboardKey.digit9.keyId;
    if (isNumber || isNumPadNumber) {
      onNumberPressed(int.parse(keyEvent.logicalKey.keyLabel));
    } else if (keyEvent.logicalKey == LogicalKeyboardKey.backspace) {
      onDeletePressed();
    } else if (keyEvent.logicalKey == LogicalKeyboardKey.period ||
        keyEvent.logicalKey == LogicalKeyboardKey.numpadDecimal) {
      onDecimalPressed();
    } else if (keyEvent.logicalKey == LogicalKeyboardKey.escape) {
      onClearPressed();
    } else if (keyEvent.logicalKey == LogicalKeyboardKey.enter ||
        keyEvent.logicalKey == LogicalKeyboardKey.numpadAdd) {
      onEnterPressed();
    } else if ((keyEvent.logicalKey == LogicalKeyboardKey.keyV &&
            keyEvent.logicalKey == LogicalKeyboardKey.control) ||
        (keyEvent.logicalKey == LogicalKeyboardKey.keyV &&
            keyEvent.logicalKey == LogicalKeyboardKey.meta)) {
      // Handle paste (Cmd+V for macOS, Ctrl+V for Windows)
      if (onPastePressed != null) {
        onPastePressed!();
      }
    }
    return false;
  }

  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKeyEvent);
  }
}
