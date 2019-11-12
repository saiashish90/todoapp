import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todos/utils/colors.dart';
import 'package:flutter_todos/widgets/shared.dart';
import 'package:flutter_todos/model/model.dart' as Model;

class Done extends StatefulWidget {
  final Function onTap;
  final Function onDeleteTask;
  final List<Model.Todo> dones;

  Done({@required this.dones, this.onTap, this.onDeleteTask});

  @override
  _DoneState createState() => _DoneState();
}

class _DoneState extends State<Done> {
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
                  getTaskItem(
                    widget.dones[i].title,
                    index: i,
                    onTap: () {
                      widget.onTap(pos: i);
                    },
                  ),
            ],
          ),
        ),
        SharedWidget.getCardHeader(
            context: context,
            text: 'DONE',
            backgroundColorCode: Colors.green,
            customFontSize: 16),
      ],
    );
  }

  Widget getTaskItem(String text,
      {@required int index, @required Function onTap}) {
    return Container(
        child: Column(
      children: <Widget>[
        Slidable(
          actionPane: SlidableDrawerActionPane(),
          key: Key(text + '$index'),
          direction: Axis.horizontal,
          actionExtentRatio: 0.25,
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
                      margin: EdgeInsets.only(left: 10, right: 10,),
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
