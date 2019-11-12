import 'package:flutter/material.dart';
import 'package:flutter_todos/widgets/shared.dart';
import 'package:flutter_todos/model/model.dart' as Model;
import 'package:flutter_todos/utils/colors.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
          text: 'TO DO',
          customFontSize: 16,
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
              actionPane: SlidableDrawerActionPane(),
              key: Key(text + '$index'),
              direction: Axis.horizontal,
              actionExtentRatio: 0.25,
              dismissal: SlidableDismissal(
                child: SlidableDrawerDismissal(),
                onDismissed: (direction) {
                  widget.onDeleteTask(todo: widget.todos[index]);
                },
              ),
              child: InkWell(
                //onTap: onTap,
                child: IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: redColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black.withOpacity(0),
                                blurRadius: 10.0,
                              ),
                            ],
                          ),
                          constraints: BoxConstraints(minHeight: 80),
                          margin:
                              EdgeInsets.only(left: 10, right: 10, bottom: 0),
                          padding: EdgeInsets.only(
                              left: 10, top: 10, right: 10, bottom: 10),
                          child: Text(
                            text,
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.justify,
                            style: Theme.of(context).textTheme.title.copyWith(
                                  color: Colors.black,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              secondaryActions: <Widget>[
                new IconSlideAction(
                  caption: 'Done',
                  color: Colors.black45,
                  icon: Icons.done,
                  onTap: onTap,
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
