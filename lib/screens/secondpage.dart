import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/to_do_model.dart';
import 'package:todo/utilities/db_helper.dart';

class SecondPage extends StatefulWidget {
  final ToDoModel toDoModel;
  final String appBarTitle;
  SecondPage(this.toDoModel, this.appBarTitle);
  @override
  _SecondPageState createState() =>
      _SecondPageState(this.toDoModel, this.appBarTitle);
}

class _SecondPageState extends State<SecondPage> {
  ToDoModel toDoModel;
  String appBarTitle;

  var _statusList = ["Pending", "Completed"];
  var selectedStatus = "Pending";

  TextEditingController _titleeditingController = TextEditingController();
  TextEditingController _descriptioneditingController = TextEditingController();

  _SecondPageState(this.toDoModel, this.appBarTitle);

  @override
  void initState() {
    selectedStatus = toDoModel.status == null ? "Pending" : toDoModel.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _titleeditingController.text = toDoModel.title;
    _descriptioneditingController.text = toDoModel.description;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            DropdownButton(
                value: selectedStatus,
                items: _statusList.map((item) {
                  return DropdownMenuItem(child: Text(item), value: item);
                }).toList(),
                onChanged: (item) {
                  setState(() {
                    selectedStatus = item;
                  });
                }),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: _titleeditingController,
              decoration: InputDecoration(
                  hintText: 'Enter Title',
                  labelText: 'Title',
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: _descriptioneditingController,
              decoration: InputDecoration(
                  hintText: 'Description',
                  labelText: 'Descri',
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 15),
                onPressed: () {
                  validate();
                },
                child: Text(
                  appBarTitle,
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }

  validate() {
    toDoModel.title = _titleeditingController.text;
    toDoModel.description = _descriptioneditingController.text;
    toDoModel.status = selectedStatus;
    toDoModel.date = DateFormat.yMMMd().format(DateTime.now());

    DataBaseHelper dataBaseHelper = DataBaseHelper();

    if (toDoModel.id == null)
      dataBaseHelper.insert(toDoModel);
    else
      dataBaseHelper.updateItem(toDoModel);

    Navigator.pop(context, true);
  }
}
