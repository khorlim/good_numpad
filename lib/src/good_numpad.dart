import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'number_keyboard_listener.dart';
import 'numpad_logic.dart';
import 'widgets/number_widget.dart';

class GoodNumPad extends StatefulWidget {
  final Widget Function(num number)? numberTitleBuilder;
  final Widget Function(int number)? numberWidgetBuilder;
  final Widget Function()? clearButtonBuilder;
  final Widget Function()? deleteButtonBuilder;
  final Widget Function()? decimalButtonBuilder;
  final bool hasDecimal;
  const GoodNumPad({
    super.key,
    this.numberTitleBuilder,
    this.numberWidgetBuilder,
    this.clearButtonBuilder,
    this.deleteButtonBuilder,
    this.decimalButtonBuilder,
    this.hasDecimal = true,
  });

  @override
  State<GoodNumPad> createState() => _GoodNumPadState();
}

class _GoodNumPadState extends State<GoodNumPad> {
  final NumPadLogic numPadLogic = NumPadLogic();
  late final NumberKeyboardListener numberKeyboardListener =
      NumberKeyboardListener(
    onNumberPressed: (number) {
      print('keyboards number pressed: $number');
      numPadLogic.onNumberPressed(number);
    },
    onDeletePressed: () {
      numPadLogic.onDeletePressed();
    },
    onDecimalPressed: () {
      if (!widget.hasDecimal) return;
      numPadLogic.onDecimalPressed();
    },
  );

  @override
  void dispose() {
    numPadLogic.dispose();
    numberKeyboardListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
              stream: numPadLogic.numberStream,
              builder: (context, snapshot) {
                num currentNum = snapshot.data ?? 0;
                return widget.numberTitleBuilder?.call(currentNum) ??
                    Container(
                      child: Center(
                        child: Text('$currentNum'),
                      ),
                    );
              }),
        ),
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            double buttHeight = constraints.maxHeight / 4;
            return GridView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: buttHeight,
              ),
              children: [
                ...List.generate(
                  9,
                  (index) {
                    int number = index + 1;
                    return CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      onPressed: () {
                        numPadLogic.onNumberPressed(number);
                      },
                      child: widget.numberWidgetBuilder?.call(number) ??
                          NumberWidget(
                            number: number,
                          ),
                    );
                  },
                ).toList(),
                CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 0,
                    onPressed: () {
                      numPadLogic.onClearPressed();
                    },
                    child:
                        widget.clearButtonBuilder?.call() ?? const Text('CLR')),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  onPressed: () {
                    numPadLogic.onNumberPressed(0);
                  },
                  child: widget.numberWidgetBuilder?.call(0) ??
                      const NumberWidget(
                        number: 0,
                      ),
                ),
                widget.hasDecimal
                    ? CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 0,
                        onPressed: () {
                          numPadLogic.onDecimalPressed();
                        },
                        child: widget.decimalButtonBuilder?.call() ??
                            const Text('.'))
                    : CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 0,
                        onPressed: () {
                          numPadLogic.onDeletePressed();
                        },
                        child: widget.deleteButtonBuilder?.call() ??
                            const Text('DLT')),
              ],
            );
          }),
        ),
      ],
    );
  }
}
