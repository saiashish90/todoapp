import 'package:flutter/material.dart';
import 'package:flutter_todos/model/db_wrapper.dart';
import 'package:flutter_todos/utils/utils.dart';

class Popup extends StatelessWidget {
  final Function getTodosAndDones;

  Popup({this.getTodosAndDones});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        child: Icon(Icons.delete_outline),
        onTap: () {
          Utils.showCustomDialog(context,
              title: 'Are you sure?',
              msg: 'All completed tasks will be deleted permanently', onConfirm: () {
            DBWrapper.sharedInstance.deleteAllDoneTodos();
            getTodosAndDones();
          });
        },
      ),
    );
  }
}
