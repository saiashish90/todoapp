import 'package:flutter/material.dart';
import 'package:flutter_todos/utils/colors.dart';

enum kMoreOptionsKeys {
  clearAll,
}

Map<int, String> kMoreOptionsMap = {
  kMoreOptionsKeys.clearAll.index: 'Clear Done',
};

class Utils {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  static String getWelcomeMessage() {
    final hour = DateTime.now().hour;
    String msg;

    if (hour < 12) {
      msg = 'Good Morning';
    } else if (hour < 18) {
      msg = 'Good Afternoon';
    } else {
      msg = 'Good Evening';
    }

    return msg;
  }

  static void showDeleteDialog(
    BuildContext context, {
    Function onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            padding: EdgeInsets.all(20),
            constraints: BoxConstraints.expand(height: 150, width: 150),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(13)),
                color: darkGreyColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("All completed tasks will be deleted", style: whiteTitle),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: redColor,
                      child: Text(
                        "Cancel",
                        style: whiteButtonTitle,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton(
                      color: redColor,
                      child: Text(
                        "Delete",
                        style: whiteButtonTitle,
                      ),
                      onPressed: () {
                        onConfirm();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static void showAddDialog(
      {BuildContext context, final Function addTaskInTodo}) {
    TextEditingController taskName = new TextEditingController();
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            padding: EdgeInsets.all(20),
            constraints: BoxConstraints.expand(height: 300, width: 300),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(13)),
                color: darkGreyColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Add New Task", style: whiteTitle),
                Container(
                  child: TextField(
                    cursorColor: Colors.white,
                    textCapitalization: TextCapitalization.sentences,
                    controller: taskName,
                    minLines: 1,
                    maxLines: 8,
                    autocorrect: true,
                    autofocus: true,
                    style: whiteButtonTitle,
                    decoration: InputDecoration(
                      hintText: "Name of task",
                      hintStyle: TextStyle(color: Colors.white70),
                      //enabledBorder: UnderlineInputBorder(
                      //borderSide: BorderSide(color: Colors.white),
                      // ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: redColor,
                      child: Text(
                        "Cancel",
                        style: whiteButtonTitle,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton(
                      color: redColor,
                      child: Text(
                        "Add",
                        style: whiteButtonTitle,
                      ),
                      onPressed: () {
                        if (taskName.text != null) {
                          addTaskInTodo(controller: taskName);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
