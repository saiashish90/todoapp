import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todos/utils/colors.dart';
import 'package:flutter_todos/widgets/shared.dart';
import 'package:flutter_todos/model/model.dart' as Model;

const int NoTask = -1;
const int animationMilliseconds = 500;

class Done extends StatefulWidget {
  final Function onTap;
  final Function onDeleteTask;
  final List<Model.Todo> dones;

  Done({@required this.dones, this.onTap, this.onDeleteTask});

  @override
  _DoneState createState() => _DoneState();
}

class _DoneState extends State<Done> {
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
              if (widget.dones == null || widget.dones.length == 0)
                Container(
                  height: 10,
                ),
              if (widget.dones != null)
                for (int i = widget.dones.length - 1; i >= 0; --i)
                  AnimatedOpacity(
                    curve: Curves.fastOutSlowIn,
                    opacity: taskPosition != i
                        ? 1.0
                        : showCompletedTaskAnimation ? 0 : 1,
                    duration: Duration(seconds: 1),
                    child: getTaskItem(
                      widget.dones[i].title,
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
            text: 'Completed Tasks',
            backgroundColorCode: Colors.green,
            customFontSize: 20),
      ],
    );
  }

  Widget getTaskItem(String text,
      {@required int index, @required Function onTap}) {
    return Container(
        child: Column(
      children: <Widget>[
        Slidable(
          controller: slidableController,
          actionPane: SlidableBehindActionPane(),
          key: Key(text + '$index'),
          direction: Axis.horizontal,
          actionExtentRatio: 0.25,
          movementDuration: Duration(milliseconds: 500),
          dismissal: SlidableDismissal(
            child: SlidableDrawerDismissal(),
            onDismissed: (direction) {
              widget.onDeleteTask(todo: widget.dones[index]);
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
                      child: Text(
                        text,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.title.copyWith(
                              color: Colors.black,
                              decoration: TextDecoration.lineThrough,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            new IconSlideAction(
              caption: 'Revert',
              color: Colors.black45,
              icon: Icons.unarchive,
              onTap: onTap,
            ),
          ],
          secondaryActions: <Widget>[
            new IconSlideAction(
              caption: 'Revert',
              color: Colors.black45,
              icon: Icons.unarchive,
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
