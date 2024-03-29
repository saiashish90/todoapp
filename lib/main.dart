import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todos/constants.dart';
import 'package:flutter_todos/utils/colors.dart';
import 'package:flutter_todos/widgets/todo.dart';
import 'package:flutter_todos/widgets/done.dart';
import 'package:flutter_todos/model/model.dart' as Model;
import 'package:flutter_todos/model/db_wrapper.dart';
import 'package:flutter_todos/utils/utils.dart';
import 'package:flutter_todos/widgets/popup.dart';

void main() => runApp(TodosApp());

class TodosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.white.withAlpha(230), // Color for Android
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness:
            Brightness.dark // Dark == white status bar -- for IOS.
        ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppTitle,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String welcomeMsg;
  List<Model.Todo> todos;
  List<Model.Todo> dones;
  //String _selection;

  @override
  void initState() {
    super.initState();
    getTodosAndDones();
    welcomeMsg = Utils.getWelcomeMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGreyColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            Utils.hideKeyboard(context);
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                floating: true,
                pinned: true,
                backgroundColor: Colors.white.withAlpha(230),
                brightness: Brightness.light,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 15.0, top: 30.0),
                                      child:
                                          Text(welcomeMsg, style: inTitleStyle),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 35),
                                      child: Popup(
                                        getTodosAndDones: getTodosAndDones,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              /*Container(
                                margin: EdgeInsets.only(top: 10),// old way of text input
                                child: TaskInput(
                                  onSubmitted: addTaskInTodo,
                                ), // Add Todos
                              ),*/
                              Container(
                                margin: EdgeInsets.only(top: 30),
                                height: 80,
                                width: 80,
                                child: FittedBox(
                                  child: FloatingActionButton(
                                      backgroundColor: redColor,
                                      tooltip: "Add a task",
                                      child: Icon(
                                        Icons.add,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        Utils.showAddDialog(
                                            context: context,
                                            addTaskInTodo: addTaskInTodo);
                                      }),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                expandedHeight: 200,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    switch (index) {
                      case 0:
                        return Todo(
                          todos: todos,
                          onTap: markTodoAsDone,
                          onDeleteTask: deleteTask,
                        ); // Active todos
                      case 1:
                        return SizedBox(
                          height: 0,
                        );
                      default:
                        return Done(
                          dones: dones,
                          onTap: markDoneAsTodo,
                          onDeleteTask: deleteTask,
                        ); // Done todos
                    }
                  },
                  childCount: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getTodosAndDones() async {
    final _todos = await DBWrapper.sharedInstance.getTodos();
    final _dones = await DBWrapper.sharedInstance.getDones();

    setState(() {
      todos = _todos;
      dones = _dones;
    });
  }

  void addTaskInTodo({@required TextEditingController controller}) {
    final inputText = controller.text.trim();

    if (inputText.length > 0) {
      // Add todos
      Model.Todo todo = Model.Todo(
        title: inputText,
        created: DateTime.now(),
        updated: DateTime.now(),
        status: Model.TodoStatus.active.index,
      );

      DBWrapper.sharedInstance.addTodo(todo);
      getTodosAndDones();
    } else {
      Utils.hideKeyboard(context);
    }

    controller.text = '';
  }

  void markTodoAsDone({@required int pos}) {
    DBWrapper.sharedInstance.markTodoAsDone(todos[pos]);
    getTodosAndDones();
  }

  void markDoneAsTodo({@required int pos}) {
    DBWrapper.sharedInstance.markDoneAsTodo(dones[pos]);
    getTodosAndDones();
  }

  void deleteTask({@required Model.Todo todo}) {
    DBWrapper.sharedInstance.deleteTodo(todo);
    getTodosAndDones();
  }
}
