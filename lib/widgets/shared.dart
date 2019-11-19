import 'package:flutter/material.dart';

class SharedWidget {
  static Widget getCardHeader(
      {@required BuildContext context,
      @required String text,
      Color textColor = Colors.white,
      Color backgroundColorCode = Colors.red,
      @required double customFontSize}) {

    return Container(
      alignment: AlignmentDirectional.center,
      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: backgroundColorCode,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: textColor,
          fontSize: customFontSize,
        ),
      ),
    );
  }
}
