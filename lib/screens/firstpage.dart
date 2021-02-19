import 'package:flutter/material.dart';
import 'package:todo/models/to_do_model.dart';
import 'package:todo/screens/secondpage.dart';
import 'package:todo/utilities/db_helper.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();

  List<ToDoModel> _todoList = null;

  int count = 0;

  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    if (_todoList == null) {
      _todoList = new List();
      updateListView();
    }
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('TO DO List'),
        centerTitle: true,
      ),
      body: populateListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigationToDetailsView(ToDoModel(""), "Add New Item");
        },
        child: Icon(Icons.add),
      ),
    );
  }

  updateListView() async {
    _todoList = await dataBaseHelper.getModelsFromMapList();
    print(_todoList);
    setState(() {
      _todoList = _todoList;
      count = _todoList.length;
    });
  }

  ListView populateListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (context, index) {
          ToDoModel toDoModel = this._todoList[index];
          return Card(
            color: toDoModel.status == "Pending" ? Colors.red : Colors.green,
            child: GestureDetector(
              onTap: () {
                navigationToDetailsView(toDoModel, "Update Item");
              },
              child: ListTile(
                leading: toDoModel.status == "Pending"
                    ? Icon(Icons.warning)
                    : Icon(Icons.done_all),
                trailing: GestureDetector(
                  child: Icon(Icons.delete),
                  onTap: () {
                    deleteItem(toDoModel);
                  },
                ),
                title: Text(toDoModel.title),
                subtitle: Text(toDoModel.description),
              ),
            ),
          );
        });
  }

  deleteItem(ToDoModel toDoModel) async {
    int result = await dataBaseHelper.delete(toDoModel);

    if (result != 0) {
      _globalKey.currentState
          .showSnackBar(SnackBar(content: Text('Item Deleted Succesfully !')));
      updateListView();
    }
  }

  navigationToDetailsView(ToDoModel toDoModel, String appBarTitle) async {
    bool results =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SecondPage(toDoModel, appBarTitle);
    }));

    if (results) {
      updateListView();
    }
  }
}
