import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/add_task.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  DatabaseReference ref = FirebaseDatabase.instance.reference();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks to do"),
      ),
      body: Container(
        child: Stack(
          children: [
            FirebaseAnimatedList(
              query: ref.child("tasks"),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                if (snapshot.value == null) {
                  return CircularProgressIndicator();
                } else {
                  return Column(
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            Text(
                              snapshot.value["title"],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 23),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text("Priority : " + snapshot.value["priority"])
                          ],
                        ),
                        subtitle: Text(
                          "Due Date : " + snapshot.value["DueDate"],
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              ref.child("tasks").child(snapshot.key).remove();
                            },
                            icon: Icon(Icons.delete)),
                        tileColor: Color(snapshot.value["color"]),
                      ),
                      Divider()
                    ],
                  );
                }
              },
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTask(),
                        ),
                      );
                    },
                    iconSize: 50,
                    icon: Icon(Icons.add),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
