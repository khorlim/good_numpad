import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NumPadLogic {
  NumPadLogic({
    num initialNum = 0,
    this.max = 999999999999,
  }) : _currentNum = initialNum;

  late num _currentNum;
  bool _isDecimal = false;
  final StreamController<num> _numberStreamController =
      StreamController<num>.broadcast();
  Stream get numberStream => _numberStreamController.stream;
  final num max;

  void updateCurrentNum(num newNum) {
    if (newNum > max) {
      newNum = max;
    }
    _currentNum = newNum;
    _numberStreamController.add(_currentNum);
  }

  void onNumberPressed(int number) {
    List<String> numStrParts = _currentNum.toString().split('.');
    int decimalCounts = numStrParts.length == 1 ? 0 : numStrParts[1].length;

    num newNum = _currentNum;
    if (_isDecimal) {
      if (decimalCounts >= 2) {
        _isDecimal = false;
      } else if (decimalCounts == 1) {
        newNum = double.parse('$newNum$number');
        _isDecimal = false;
      } else if (decimalCounts == 0) {
        newNum = double.parse('$newNum.$number');
      }
    } else {
      newNum = num.parse(
          '${numStrParts[0]}$number${numStrParts.length == 1 ? '' : '.${numStrParts[1]}'}');
    }
    updateCurrentNum(newNum);
  }

  void onClearPressed() {
    _isDecimal = false;
    updateCurrentNum(0);
  }

  void onDeletePressed() {
    List<String> numStrParts = _currentNum.toString().split('.');
    String numStr = numStrParts[0];
    num newNum = _currentNum;

    if (numStr.isNotEmpty) {
      newNum = num.parse(
          '${numStr.length == 1 ? '0' : numStr.substring(0, numStr.length - 1)}${numStrParts.length == 1 ? '' : '.${numStrParts[1]}'}');
    }

    updateCurrentNum(newNum);
  }

  void onDecimalPressed() {
    _isDecimal = true;
    num newNum = _currentNum.toInt();
    updateCurrentNum(newNum);
  }

  void dispose() {
    _numberStreamController.close();
  }
}
