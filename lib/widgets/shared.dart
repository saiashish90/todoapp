import 'package:flutter/material.dart';

class SharedWidget {
  static Widget getCardHeader(
      {@required BuildContext context,
      @required String text,
      Color textColor = Colors.white,
      Color backgroundColorCode = Colors.red,
      double customFontSize}) {
    customFontSize ??= Theme.of(context).textTheme.title.fontSize;

    return Container(
      alignment: AlignmentDirectional.center,
      margin: EdgeInsets.only(left:10, right: 10, top: 20),
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

  static Widget getOnDismissDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      color: Colors.red[300],
      padding: EdgeInsets.only(right: 10),
      child: Text(
        'DELETE',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
