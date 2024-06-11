import 'package:flutter/services.dart';

class NumberKeyboardListener {
  NumberKeyboardListener({
    required this.onNumberPressed,
    required this.onDeletePressed,
    required this.onDecimalPressed,
    required this.onClearPressed,
  }) {
    HardwareKeyboard.instance.addHandler(_onKeyEvent);
  }

  final void Function(int number) onNumberPressed;
  final void Function() onDeletePressed;
  final void Function() onDecimalPressed;
  final void Function() onClearPressed;

  bool _onKeyEvent(KeyEvent keyEvent) {
    if (keyEvent is! KeyDownEvent) {
      return false;
    }
    bool isNumber =
        keyEvent.logicalKey.keyId >= LogicalKeyboardKey.digit0.keyId &&
            keyEvent.logicalKey.keyId <= LogicalKeyboardKey.digit9.keyId;
    if (isNumber) {
      onNumberPressed(int.parse(keyEvent.logicalKey.keyLabel));
    } else if (keyEvent.logicalKey == LogicalKeyboardKey.backspace) {
      onDeletePressed();
    } else if (keyEvent.logicalKey == LogicalKeyboardKey.period) {
      onDecimalPressed();
    } else if (keyEvent.logicalKey == LogicalKeyboardKey.numpadDecimal) {
      onDecimalPressed();
    } else if (keyEvent.logicalKey == LogicalKeyboardKey.escape) {
      onClearPressed();
    }

    return false;
  }

  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKeyEvent);
  }
}
