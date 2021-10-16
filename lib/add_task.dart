import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  var _taskController = TextEditingController();
  DateTime picked = null;
  String dropdown = "High";
  int color = 0xFFF448336;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
      ),
      body: Form(
        key: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Task Title",
                  labelText: "Task Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  )),
              controller: _taskController,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "please add tasks";
                }
                return null;
              },
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15)),
              child: picked == null
                  ? ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text(
                        "Select Due Date",
                      ),
                      onTap: () {
                        _selectDate(context);
                      },
                    )
                  : ListTile(
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _selectDate(context);
                        },
                      ),
                      title: Text(
                        "Due Date:" +
                            picked.day.toString() +
                            "/" +
                            picked.month.toString() +
                            "/" +
                            picked.year.toString(),
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                  ),
                  Center(
                    child: Text(
                      "Select Priority:",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  DropdownButton(
                      value: dropdown,
                      onChanged: (String newval) {
                        setState(() {
                          if (newval == "High") {
                            color = 0xFFF44336;
                          } else if (newval == "Medium") {
                            color = 0xFFFF9800;
                          } else {
                            color = 0xFF009688;
                          }
                          dropdown = newval;
                        });
                      },
                      items: <String>['High', 'Medium', 'Low']
                          .map<DropdownMenuItem<String>>((String e) {
                        return DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        );
                      }).toList()),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15)),
              child: TextButton(
                onPressed: () {
                  if (_key.currentState.validate()) {
                    FirebaseDatabase.instance
                        .reference()
                        .child("tasks")
                        .push()
                        .set({
                      "title": _taskController.text,
                      "DueDate": picked.day.toString() +
                          "/" +
                          picked.month.toString() +
                          "/" +
                          picked.year.toString(),
                      "priority": dropdown,
                      "color": color,
                    }).then((value) => Navigator.of(context).pop());
                  }
                },
                child: Text(
                  "Add",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    setState(() {
      picked = this.picked;
    });
  }
}
