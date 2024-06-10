import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class NumberWidget extends StatelessWidget {
  final int number;
  const NumberWidget({
    super.key,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          number.toString(),
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
