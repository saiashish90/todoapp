import 'package:flutter/material.dart';
import 'package:flutter_todos/widgets/shared.dart';
import 'package:flutter_todos/model/model.dart' as Model;
import 'package:flutter_todos/utils/colors.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share/share.dart';

const int NoTask = -1;
const int animationMilliseconds = 500;

class Todo extends StatefulWidget {
  final Function onTap;
  final Function onDeleteTask;
  final List<Model.Todo> todos;

  Todo({@required this.todos, this.onTap, this.onDeleteTask});

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  int taskPosition = NoTask;
  bool showCompletedTaskAnimation = false;
  final SlidableController slidableController = SlidableController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          color: Colors.transparent,
          elevation: 0,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              if (widget.todos == null || widget.todos.length == 0)
                Container(
                  height: 100,
                ),
              if (widget.todos != null)
                for (int i = 0; i < widget.todos.length; ++i)
                  AnimatedOpacity(
                    curve: Curves.fastOutSlowIn,
                    opacity: taskPosition != i
                        ? 1.0
                        : showCompletedTaskAnimation ? 0 : 1,
                    duration: Duration(seconds: 1),
                    child: getTaskItem(
                      widget.todos[i].title,
                      index: i,
                      onTap: () {
                        setState(() {
                          taskPosition = i;
                          showCompletedTaskAnimation = true;
                        });
                        Future.delayed(
                          Duration(milliseconds: animationMilliseconds),
                        ).then((value) {
                          taskPosition = NoTask;
                          showCompletedTaskAnimation = false;
                          widget.onTap(pos: i);
                        });
                      },
                    ),
                  ),
            ],
          ),
        ),
        SharedWidget.getCardHeader(
          context: context,
          text: 'Tasks',
          customFontSize: 20,
          backgroundColorCode: Colors.red.withAlpha(215),
        ),
      ],
    );
  }

  Widget getTaskItem(String text,
      {@required int index, @required Function onTap}) {
    return Container(
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            Slidable(
              controller: slidableController,
              actionPane: SlidableBehindActionPane(),
              key: Key(text + '$index'),
              direction: Axis.horizontal,
              actionExtentRatio: 0.15,
              movementDuration: Duration(milliseconds: 500),
              dismissal: SlidableDismissal(
                child: SlidableDrawerDismissal(),
                onDismissed: (direction) {
                  widget.onDeleteTask(todo: widget.todos[index]);
                },
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: redColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      constraints: BoxConstraints(minHeight: 80),
                      margin: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      padding: EdgeInsets.only(
                          left: 10, top: 10, right: 10, bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          
                          Container(
                            height: 40,
                            width: 40,
                            child: FittedBox(
                              child: FloatingActionButton(
                                elevation: 0,
                                tooltip: "Mark as done",
                                backgroundColor: Colors.transparent,
                                onPressed: onTap,
                                child: Icon(
                                  Icons.radio_button_unchecked,
                                  size: 35,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Text(
                              text,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.justify,
                              style:
                                  Theme.of(context).textTheme.title.copyWith(
                                        color: Colors.black,
                                      ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              actions: <Widget>[
               
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new IconSlideAction(
                      caption: 'Share',
                      color: darkGreyColor,
                      icon: Icons.share,
                      onTap: () {
                        Share.share(text);
                      },
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              color: Colors.grey,
            ),
          ],
        ));
  }
}
