import 'dart:async';

import 'numpad_config.dart';

class NumPadLogic {
  NumPadLogic({
    num initialNum = 0,
    NumPadConfig? config,
  }) {
    _config = config ?? NumPadConfig(maxValue: 999999999, minValue: 0);
    updateCurrentNum(initialNum);
  }

  late num _showingNum;
  late num _currentNum;
  num get showingNum => _showingNum;
  num get currentNum => _currentNum;
  bool _isDecimal = false;
  final StreamController<num> _numberStreamController =
      StreamController<num>.broadcast();
  Stream<num> get numberStream => _numberStreamController.stream;
  late NumPadConfig _config;

  void updateCurrentNum(num newNum) {
    if (newNum > _config.maxValue) {
      newNum = _config.maxValue;
    }
    _currentNum = newNum;

    updateShowingNum(newNum);
  }

  void updateShowingNum(num newNum) {
    _showingNum = newNum;
    _numberStreamController.add(_currentNum);
  }

  void updateConfig(NumPadConfig config) {
    _config = config;
    if (currentNum > _config.maxValue) {
      updateCurrentNum(_config.maxValue);
    } else if (currentNum < config.minValue) {
      updateCurrentNum(_config.minValue);
    }
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
